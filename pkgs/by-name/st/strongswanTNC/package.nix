{
  strongswan,
  ...
}@args:

strongswan.override (
  {
    enableTNC = true;
  }
  // removeAttrs args [ "strongswan" ]
)
