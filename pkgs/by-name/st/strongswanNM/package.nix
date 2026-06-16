{
  strongswan,
  ...
}@args:

strongswan.override (
  {
    enableNetworkManager = true;
  }
  // removeAttrs args [ "strongswan" ]
)
