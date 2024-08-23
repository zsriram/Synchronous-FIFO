module sync_fifo(
    input clk,
    input rst_n,

    input wr_en_i,
    input [7:0] data_i,
    output full_o,

    input rd_en_i,
    output reg [7:0] data_o,
    output empty_o
);
    parameter DEPTH = 8;
	
	reg [7:0] mem [0:DEPTH-1]; /*this is an 8-bit array with a depth of 8 => depth specifies the number of elements in the array and the 'n-bit array' specifies the number of bits in each element.*/
 	
	reg [2:0] wr_ptr;
	reg [2:0] rd_ptr;
	reg [3:0] count;
	
	assign full_o = (count == DEPTH? 1 : 0);
	assign empty_o = (count == 0 ? 1 : 0);
	
	/* this always block handles the write process */
	
	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			wr_ptr <= 0;
		end
		
		else begin
			if(wr_en_i == 1)begin
				mem[wr_ptr] <= data_i;
				wr_ptr <= wr_ptr + 1;
			end
		end
	end
	
	/* this always block handles the read process */
	
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			rd_ptr <= 0;
		end
		
		else begin
			if(rd_en_i) begin
				data_o <= mem[rd_ptr];
				rd_ptr <= rd_ptr + 1;
			end
		end
	end
	
	
	/*This always block handles count */
		
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			count <= 0;
		end
		
		else begin
			case ({wr_en_i,rd_en_i}) 
				2'd0: count<=count;
				2'd1: count <= count - 1;
				2'd2: count <= count + 1;
				2'd3: count <= count;
				default: count <= count;
			endcase 
	end
	end
endmodule