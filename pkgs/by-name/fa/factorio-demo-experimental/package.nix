{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "demo";
    experimental = true;
  }
  // removeAttrs args [ "factorio" ]
)
