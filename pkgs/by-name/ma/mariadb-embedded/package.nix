{
  mariadb,
  ...
}@args:

mariadb.override (
  {
    withEmbedded = true;
  }
  // removeAttrs args [ "mariadb" ]
)
