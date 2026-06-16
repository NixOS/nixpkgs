{
  gdb,
  ...
}@args:

gdb.override (
  {
    hostCpuOnly = true;
  }
  // removeAttrs args [ "gdb" ]
)
