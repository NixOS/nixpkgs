{
  opensplat,
  ...
}@args:

opensplat.override (
  {
    rocmSupport = true;
  }
  // removeAttrs args [ "opensplat" ]
)
