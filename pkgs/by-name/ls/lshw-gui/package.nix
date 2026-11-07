{
  lshw,
  ...
}@args:

lshw.override (
  {
    withGUI = true;
  }
  // removeAttrs args [ "lshw" ]
)
