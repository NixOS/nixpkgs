module helloworld (
    input wire[7:0] a,
    input wire[7:0] b,
    output wire[7:0] c,
);
    assign c = a + b;
endmodule
