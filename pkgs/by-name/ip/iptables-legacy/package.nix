{
  iptables,
  ...
}@args:

(iptables.override (
  {
    nftablesCompat = false;
  }
  // removeAttrs args [ "iptables" ]
))
