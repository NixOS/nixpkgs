{
  ghdl,
  ...
}@args:

ghdl.override (
  {
    backend = "gcc";
  }
  // removeAttrs args [ "ghdl" ]
)
