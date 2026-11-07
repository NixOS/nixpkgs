{
  factorio,
  ...
}@args:

factorio.override (
  {
    releaseType = "headless";
    experimental = true;
  }
  // removeAttrs args [ "factorio" ]
)
