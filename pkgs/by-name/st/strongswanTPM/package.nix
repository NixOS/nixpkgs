{
  strongswan,
  ...
}@args:
# nixpkgs-update: no auto update
strongswan.override (
  {
    enableTPM2 = true;
  }
  // removeAttrs args [ "strongswan" ]
)
