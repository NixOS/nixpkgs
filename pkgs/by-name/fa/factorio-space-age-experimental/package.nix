{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "expansion";
    experimental = true;
  }
  // removeAttrs args [ "factorio" ]
)
