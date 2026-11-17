{ runTest }:

{
  initrd = runTest ./initrd.nix;
  initrd-partial-broken-config = runTest ./initrd-partial-broken-config.nix;
  initrd-wireguard = runTest ./initrd-wireguard.nix;
  partial-broken-config = runTest ./partial-broken-config.nix;
  ping = runTest ./ping.nix;
  wireguard = runTest ./wireguard.nix;
}
