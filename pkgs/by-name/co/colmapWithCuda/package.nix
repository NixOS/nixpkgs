{
  colmap,
  ...
}@args:

colmap.override (
  {
    cudaSupport = true;
  }
  // removeAttrs args [ "colmap" ]
)
