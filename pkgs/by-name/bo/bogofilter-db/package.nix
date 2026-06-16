{
  bogofilter,
  db,
  ...
}@args:

bogofilter.override (
  {
    database = db;
  }
  // removeAttrs args [
    "bogofilter"
    "db"
  ]
)
