{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4113";
      x64sha256 = "13679mnmigy1sgj355zs4si6gnx42rgjl4rn5d6gqgj5qq7zj3lh";
      aarch64sha256 = "0hg6g3cichma1x82963m7xwazmpdvv5zmz8rpwxs337zq7j3dmb3";
    } {};

    sublime4-dev = common {
      buildVersion = "4112";
      dev = true;
      x64sha256 = "1yy8wzcphsk3ji2sv2vjcw8ybn62yibzsv9snmm01gvkma16p9dl";
      aarch64sha256 = "12bl235rxgw3q99yz9x4nfaryb32a2vzyam88by6p1s1zw2fxnp9";
    } {};
  }
