with import ../../.. {};
with import ./vm.nix;

rec {


  # Run the PatchELF derivation in a VM.
  buildPatchelfInVM = runInLinuxVM patchelf;


  rpmImage = fillDiskWithRPMs {
    name = "fedora-image";
    fullName = "Fedora Core 3";
    size = 1024;
    rpms = import ./rpm/fedora-3-packages.nix {inherit fetchurl;};
  };


  testRPMImage = makeImageTestScript rpmImage;


  buildPatchelfRPM = buildRPM {
    name = "patchelf-rpm";
    src = patchelf.src;
    diskImage = rpmImage;
  };

  
  ubuntuImage = fillDiskWithDebs {
    name = "ubuntu-image";
    fullName = "Ubuntu 7.10 Gutsy";
    size = 256;
    debs = import ./deb/ubuntu-7.10-gutsy-i386.nix {inherit fetchurl;};
  };
  

  debianImage = fillDiskWithDebs {
    name = "debian-image";
    fullName = "Debian 4.0r3 Etch";
    size = 256;
    debs = import ./deb/debian-4.0r3-etch-i386.nix {inherit fetchurl;};
  };


  testUbuntuImage = makeImageTestScript ubuntuImage;

  
  buildInDebian = runInLinuxImage (stdenv.mkDerivation {
    name = "deb-compile";
    src = nixUnstable.src;
    diskImage = debianImage;
    memSize = 512;
  });
  

  
}