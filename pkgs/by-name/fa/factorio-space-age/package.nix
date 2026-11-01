{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "expansion";
  }
  // removeAttrs args [ "factorio" ]
)
