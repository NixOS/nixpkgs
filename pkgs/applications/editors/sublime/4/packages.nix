{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4152";
      x64sha256 = "bt48g1GZWYlwQcZQboUHU8GZYmA7cb2fc6Ylrh5NNVQ=";
      aarch64sha256 = "nSH5a5KRYzqLMnLo2mFk3WpjL9p6Qh3zNy8oFPEHHoA=";
    } {};

    sublime4-dev = common {
      buildVersion = "4150";
      dev = true;
      x64sha256 = "6Kafp4MxmCn978SqjSY8qAT6Yc/7WC8U9jVkIUUmUHs=";
      aarch64sha256 = "dPxe2RLoMJS+rVtcVZZpMPQ5gfTEnW/INcnzYYeFEIQ=";
    } {};
  }
