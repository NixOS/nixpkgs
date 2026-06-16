{
  alice-tools,
  ...
}@args:

alice-tools.override (
  {
    withQt5 = true;
  }
  // removeAttrs args [ "alice-tools" ]
)
