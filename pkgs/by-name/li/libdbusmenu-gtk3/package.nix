{
  libdbusmenu,
  ...
}@args:

libdbusmenu.override (
  {
    gtkVersion = "3";
  }
  // removeAttrs args [ "libdbusmenu" ]
)
