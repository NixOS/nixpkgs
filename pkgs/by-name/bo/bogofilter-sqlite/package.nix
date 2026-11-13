{
  bogofilter,
  sqlite,
  ...
}@args:

bogofilter.override (
  {
    database = sqlite;
  }
  // removeAttrs args [
    "bogofilter"
    "sqlite"
  ]
)
