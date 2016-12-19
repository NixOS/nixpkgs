{ stdenv, fetchurl, callPackage, ignition, gazeboSimulator, ... } @ args:

callPackage ./default.nix (args // rec {
  version = "6.5.1";
  src-sha256 = "96260aa23f1a1f24bc116f8e359d31f3bc65011033977cb7fb2c64d574321908";
  sdformat = gazeboSimulator.sdformat3;
})

