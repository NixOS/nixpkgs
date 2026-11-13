{
  libdbusmenu,
  ...
}@args:

libdbusmenu.override (
  {
    withGtk3 = true;
  }
  // removeAttrs args [ "libdbusmenu" ]
)
