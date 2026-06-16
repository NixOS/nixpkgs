{
  btop,
  ...
}@args:

btop.override (
  {
    rocmSupport = true;
  }
  // removeAttrs args [ "btop" ]
)
