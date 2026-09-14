{
  jabcode,
  ...
}@args:

jabcode.override (
  {
    subproject = "writer";
  }
  // removeAttrs args [ "jabcode" ]
)
