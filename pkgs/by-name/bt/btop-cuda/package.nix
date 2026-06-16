{
  btop,
  ...
}@args:

btop.override (
  {
    cudaSupport = true;
  }
  // removeAttrs args [ "btop" ]
)
