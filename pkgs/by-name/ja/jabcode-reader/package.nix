{
  jabcode,
  ...
}@args:

jabcode.override (
  {
    subproject = "reader";
  }
  // removeAttrs args [ "jabcode" ]
)
