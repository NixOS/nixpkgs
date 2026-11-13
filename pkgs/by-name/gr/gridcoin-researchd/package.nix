{
  gridcoin-research,
  ...
}@args:

gridcoin-research.override (
  {
    withGui = false;
  }
  // removeAttrs args [ "gridcoin-research" ]
)
