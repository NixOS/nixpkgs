with import ../../.. { };
with vmTools;

{


  # Run the PatchELF derivation in a VM.
  buildPatchelfInVM = runInLinuxVM patchelf;

  buildHelloInVM = runInLinuxVM hello;

  buildPanInVM = runInLinuxVM pan;


  testRPMImage = makeImageTestScript diskImages.fedora16x86_64;


  buildPatchelfRPM = buildRPM {
    name = "patchelf-rpm";
    src = patchelf.src;
    diskImage = diskImages.fedora16x86_64;
  };


  testUbuntuImage = makeImageTestScript diskImages.ubuntu810i386;


  buildInDebian = runInLinuxImage (stdenv.mkDerivation {
    name = "deb-compile";
    src = patchelf.src;
    diskImage = diskImages.ubuntu1204i386;
    memSize = 512;
    prePhases = [ sysInfoPhase ];
    sysInfoPhase = ''
      dpkg-query --list
    '';
  });

}
