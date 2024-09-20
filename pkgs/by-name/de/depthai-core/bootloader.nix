{ fetchurl }:

let
  bootloader_version = "0.0.24";
  bootloader_filename = "depthai-bootloader-fwp-${bootloader_version}.tar.xz";
in

fetchurl {
  name = bootloader_filename;
  version = bootloader_version;
  url = "https://artifacts.luxonis.com/artifactory/luxonis-myriad-release-local/depthai-bootloader/${bootloader_version}/${bootloader_filename};unpack=0;name=bootloader-fwp";
  hash = "sha256-yRPGNshmUuqW7aITWlF2IPfVKNY1fdxpft+iB2KnyzA=";
}
