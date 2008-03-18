with import ../../.. {};
with vmTools;

rec {


  # Run the PatchELF derivation in a VM.
  buildPatchelfInVM = runInLinuxVM patchelf;


  testRPMImage = makeImageTestScript diskImages.suse90i386;


  buildPatchelfRPM = buildRPM {
    name = "patchelf-rpm";
    src = patchelf.src;
    diskImage = diskImages.fedora5i386;
  };

  
  testUbuntuImage = makeImageTestScript diskImages.ubuntu710i386;

  
  buildInDebian = runInLinuxImage (stdenv.mkDerivation {
    name = "deb-compile";
    src = nixUnstable.src;
    diskImage = diskImages.debian40r3i386;
    memSize = 512;
    phases = "sysInfoPhase unpackPhase patchPhase configurePhase buildPhase checkPhase installPhase fixupPhase distPhase";
    sysInfoPhase = ''
      dpkg-query --list
    '';
  });
  

  
}