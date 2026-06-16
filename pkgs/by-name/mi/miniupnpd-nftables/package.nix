{
  miniupnpd,
  ...
}@args:

miniupnpd.override (
  {
    firewall = "nftables";
  }
  // removeAttrs args [ "miniupnpd" ]
)
