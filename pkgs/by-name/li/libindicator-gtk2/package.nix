{
  libindicator,
  ...
}@args:

libindicator.override (
  {
    gtkVersion = "2";
  }
  // removeAttrs args [ "libindicator" ]
)
