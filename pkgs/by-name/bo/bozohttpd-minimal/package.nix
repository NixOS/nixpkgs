{
  bozohttpd,
  ...
}@args:

bozohttpd.override (
  {
    minimal = true;
  }
  // removeAttrs args [ "bozohttpd" ]
)
