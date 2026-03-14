{ runTest }:
{
  dhcp4-ddns = runTest ./dhcp4-ddns.nix;
  dhcp6-postgres = runTest ./dhcp6-postgres.nix;
}
