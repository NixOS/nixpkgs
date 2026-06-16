{
  pgadmin4,
  ...
}@args:

pgadmin4.override (
  {
    server-mode = false;
  }
  // removeAttrs args [ "pgadmin4" ]
)
