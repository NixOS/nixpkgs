{
  libindicator,
  ...
}@args:

libindicator.override (
  {
    gtkVersion = "3";
  }
  // removeAttrs args [ "libindicator" ]
)
