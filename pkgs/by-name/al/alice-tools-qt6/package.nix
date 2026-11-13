{
  alice-tools,
  ...
}@args:

alice-tools.override (
  {
    withQt6 = true;
  }
  // removeAttrs args [ "alice-tools" ]
)
