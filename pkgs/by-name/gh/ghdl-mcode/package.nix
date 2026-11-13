{
  ghdl,
  ...
}@args:

ghdl.override (
  {
    backend = "mcode";
  }
  // removeAttrs args [ "ghdl" ]
)
