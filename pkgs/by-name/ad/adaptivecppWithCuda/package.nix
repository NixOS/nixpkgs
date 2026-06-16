{
  adaptivecpp,
  ...
}@args:

adaptivecpp.override (
  {
    cudaSupport = true;
  }
  // removeAttrs args [ "adaptivecpp" ]
)
