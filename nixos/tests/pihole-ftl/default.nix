{ runTest }:

{
  basic = runTest ./basic.nix;
  dnsmasq = runTest ./dnsmasq.nix;
  log-deleter = runTest ./log-deleter.nix;
}
