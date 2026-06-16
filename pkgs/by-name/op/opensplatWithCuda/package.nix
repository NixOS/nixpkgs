{
  opensplat,
  ...
}@args:

opensplat.override (
  {
    cudaSupport = true;
  }
  // removeAttrs args [ "opensplat" ]
)
