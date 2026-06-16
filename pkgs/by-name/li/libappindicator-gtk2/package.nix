{
  libappindicator,
  ...
}@args:

libappindicator.override (
  {
    gtkVersion = "2";
  }
  // removeAttrs args [ "libappindicator" ]
)
