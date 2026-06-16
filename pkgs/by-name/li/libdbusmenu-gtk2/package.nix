{
  libdbusmenu,
  ...
}@args:

libdbusmenu.override (
  {
    gtkVersion = "2";
  }
  // removeAttrs args [ "libdbusmenu" ]
)
