with import ../../.. { };
with vmTools;

{


  # Run the PatchELF derivation in a VM.
  buildPatchelfInVM = runInLinuxVM patchelf;

  buildHelloInVM = runInLinuxVM hello;

  buildPanInVM = runInLinuxVM (pan // { memSize = 2048; });


  testRPMImage = makeImageTestScript diskImages.fedora27x86_64;


  buildPatchelfRPM = buildRPM {
    name = "patchelf-rpm";
    src = patchelf.src;
    diskImage = diskImages.fedora27x86_64;
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
