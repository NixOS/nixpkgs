{
  sqlite,
  ...
}@args:

sqlite.override (
  {
    interactive = true;
  }
  // removeAttrs args [ "sqlite" ]
)
