{
  raxml,
  ...
}@args:

raxml.override (
  {
    useMpi = true;
  }
  // removeAttrs args [ "raxml" ]
)
