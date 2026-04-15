{ lib, runTest }:
lib.recurseIntoAttrs {
  basic = runTest ./basic.nix;
  firewall = runTest ./firewall.nix;
  plugins = runTest ./plugins.nix;
}
