{
  libappindicator,
  ...
}@args:

libappindicator.override (
  {
    gtkVersion = "3";
  }
  // removeAttrs args [ "libappindicator" ]
)
