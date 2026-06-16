{
  libnma,
  ...
}@args:

libnma.override (
  {
    withGtk4 = true;
  }
  // removeAttrs args [ "libnma" ]
)
