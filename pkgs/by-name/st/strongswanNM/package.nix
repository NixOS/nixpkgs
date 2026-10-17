{
  strongswan,
  ...
}@args:
# nixpkgs-update: no auto update
strongswan.override (
  {
    enableNetworkManager = true;
  }
  // removeAttrs args [ "strongswan" ]
)
