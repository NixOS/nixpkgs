{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4-dev = common {
      buildVersion = "4079";
      dev = true;
      x64sha256 = "8F4WlsV/MrenkA/NDm5z27S0IyVDWSNUdu+mZvYCYrM=";
      aarch64sha256 = "ruOherOGFpDwr8NiTyRCflj0bXOT0tTDWvYbquDZXsw=";
    } {};
  }
