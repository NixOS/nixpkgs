{
  strongswan,
  ...
}@args:
# nixpkgs-update: no auto update
strongswan.override (
  {
    enableTNC = true;
  }
  // removeAttrs args [ "strongswan" ]
)
