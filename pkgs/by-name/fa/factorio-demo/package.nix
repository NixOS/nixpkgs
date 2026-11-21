{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "demo";
  }
  // removeAttrs args [ "factorio" ]
)
