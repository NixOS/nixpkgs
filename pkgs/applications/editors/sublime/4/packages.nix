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
      buildVersion = "4106";
      dev = true;
      x64sha256 = "09jnn52zb0mjxpj5xz4sixl34cr6j60x46c2dj1m0dlgxap0sh8x";
      aarch64sha256 = "7blbeSZI0V6q89jMM+zi2ODEdoc1b3Am8F2b2jLr5O8=";
    } {};
  }
