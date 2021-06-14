{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4107";
      x64sha256 = "05ar7qd1d880442bx4w32mapsib7j27g9l96q2v2s7591r9fgnf7";
      aarch64sha256 = "4MzwhZ17c6cYtlwPA+SBiey6GiVruADXOLJAeJlMrgM=";
    } {};

    sublime4-dev = common {
      buildVersion = "4106";
      dev = true;
      x64sha256 = "09jnn52zb0mjxpj5xz4sixl34cr6j60x46c2dj1m0dlgxap0sh8x";
      aarch64sha256 = "7blbeSZI0V6q89jMM+zi2ODEdoc1b3Am8F2b2jLr5O8=";
    } {};
  }
