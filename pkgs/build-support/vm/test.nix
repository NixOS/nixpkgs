with import ../../.. { };
with vmTools;

{


  # Run the PatchELF derivation in a VM.
  buildPatchelfInVM = runInLinuxVM patchelf;

  buildHelloInVM = runInLinuxVM hello;

  buildPcmanrmInVM = runInLinuxVM (pcmanfm.overrideAttrs (old: {
    # goes out-of-memory with many cores
    enableParallelBuilding = false;
  }));

  testRPMImage = makeImageTestScript diskImages.fedora27x86_64;


  buildPatchelfRPM = buildRPM {
    name = "patchelf-rpm";
    src = patchelf.src;
    diskImage = diskImages.fedora27x86_64;
    diskImageFormat = "qcow2";
  };


  testUbuntuImage = makeImageTestScript diskImages.ubuntu1804i386;


  buildInDebian = runInLinuxImage (stdenv.mkDerivation {
    name = "deb-compile";
    src = patchelf.src;
    diskImage = diskImages.ubuntu1804i386;
    diskImageFormat = "qcow2";
    memSize = 512;
    postHook = ''
      dpkg-query --list
    '';
  });

}
