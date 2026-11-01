{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "headless";
  }
  // removeAttrs args [ "factorio" ]
)
