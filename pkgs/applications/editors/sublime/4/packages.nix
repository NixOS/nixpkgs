{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4143";
      x64sha256 = "fehiw40ZNnQUEXEQMo3e11SscJ/tVMjMXLBzfIlMBzw=";
      aarch64sha256 = "4zpNHVEHO98vHcWTbqmwlrB4+HIwoQojeQvq7nAqSpM=";
    } {};

    sublime4-dev = common {
      buildVersion = "4150";
      dev = true;
      x64sha256 = "6Kafp4MxmCn978SqjSY8qAT6Yc/7WC8U9jVkIUUmUHs=";
      aarch64sha256 = "dPxe2RLoMJS+rVtcVZZpMPQ5gfTEnW/INcnzYYeFEIQ=";
    } {};
  }
