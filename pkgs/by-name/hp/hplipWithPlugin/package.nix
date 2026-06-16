{
  hplip,
  ...
}@args:

hplip.override (
  {
    withPlugin = true;
  }
  // removeAttrs args [ "hplip" ]
)
