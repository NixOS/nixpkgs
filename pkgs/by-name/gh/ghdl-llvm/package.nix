{
  ghdl,
  ...
}@args:

ghdl.override (
  {
    backend = "llvm";
  }
  // removeAttrs args [ "ghdl" ]
)
