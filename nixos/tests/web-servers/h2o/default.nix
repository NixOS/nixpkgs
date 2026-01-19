{ lib, runTest }:
lib.recurseIntoAttrs {
  basic = runTest ./basic.nix;
  mruby = runTest ./mruby.nix;
  tls-recommendations = runTest ./tls-recommendations.nix;
}
