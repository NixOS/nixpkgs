{
  nest,
  ...
}@args:

nest.override (
  {
    withMpi = true;
  }
  // removeAttrs args [ "nest" ]
)
