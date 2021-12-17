{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4121";
      x64sha256 = "CE/PeUV8Mg1Z2h8OWMhaemOVa95B1k2wHsht8lVPxeY=";
      aarch64sha256 = "eveEW0Aq6pim0lnQ6BfISRaBgogeofgLmOVylSVojwg=";
    } {};

    sublime4-dev = common {
      buildVersion = "4112";
      dev = true;
      x64sha256 = "1yy8wzcphsk3ji2sv2vjcw8ybn62yibzsv9snmm01gvkma16p9dl";
      aarch64sha256 = "12bl235rxgw3q99yz9x4nfaryb32a2vzyam88by6p1s1zw2fxnp9";
    } {};
  }
