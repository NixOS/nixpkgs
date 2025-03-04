{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime4 = common {
    buildVersion = "4192";
    x64sha256 = "3CMorzQj+JFPTXp6PPhX6Mlcz/kJb2FM2iwUsvrhy+s=";
    aarch64sha256 = "gVhDBac3kyDU1qIiXoN7Xf5Jvbdnif2QGuFUy2C34Mo=";
  } { };

  sublime4-dev = common {
    buildVersion = "4191";
    dev = true;
    x64sha256 = "fJy0BNToM8beMv5jYdFiecyjudzTG+r0mEpi9erZs4A=";
    aarch64sha256 = "KgqZ9+rEGM9wcgqk+CenFInmDc3jPMdnRBpTREHBpjE=";
  } { };
}
