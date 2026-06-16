{
  adaptivecpp,
  ...
}@args:

adaptivecpp.override (
  {
    rocmSupport = true;
  }
  // removeAttrs args [ "adaptivecpp" ]
)
