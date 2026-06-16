{
  strongswan,
  ...
}@args:

strongswan.override (
  {
    enableTPM2 = true;
  }
  // removeAttrs args [ "strongswan" ]
)
