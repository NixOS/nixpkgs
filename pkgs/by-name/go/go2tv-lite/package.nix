{
  go2tv,
  ...
}@args:

go2tv.override (
  {
    withGui = false;
  }
  // removeAttrs args [ "go2tv" ]
)
