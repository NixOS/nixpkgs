{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "alpha";
    experimental = true;
  }
  // removeAttrs args [ "factorio" ]
)
