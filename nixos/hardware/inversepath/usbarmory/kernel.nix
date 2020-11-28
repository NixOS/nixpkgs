{ stdenv, buildLinux, fetchurl }:

buildLinux {
  inherit stdenv;
  version = "4.4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-4.4.tar.xz";
    sha256 = "401d7c8fef594999a460d10c72c5a94e9c2e1022f16795ec51746b0d165418b2";
  };

  configfile = ./kernel.config;

  kernelPatches = [{
    patch = ./usbarmory-dts.patch;
    name = "usbarmory-dts";
  }];

  allowImportFromDerivation = true;
}
