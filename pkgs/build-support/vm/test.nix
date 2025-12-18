{
  hello,
  patchelf,
  pcmanfm,
  stdenv,
  vmTools,
}:
let
  inherit (vmTools)
    buildRPM
    diskImages
    makeImageTestScript
    runInLinuxImage
    runInLinuxVM
    ;
in

{
  buildPatchelfInVM = runInLinuxVM patchelf;
  buildPatchelfInDebian = runInLinuxImage (
    stdenv.mkDerivation {
      inherit (patchelf) pname version src;

      diskImage = diskImages.debian13x86_64;
      diskImageFormat = "qcow2";
      memSize = 512;
    }
  );

  buildHelloInVM = runInLinuxVM hello;
  buildStructuredAttrsHelloInVM = runInLinuxVM (hello.overrideAttrs { __structuredAttrs = true; });
  buildHelloInFedora = runInLinuxImage (
    stdenv.mkDerivation {
      inherit (hello) pname version src;

      diskImage = diskImages.fedora42x86_64;
      diskImageFormat = "qcow2";
      memSize = 512;
    }
  );

  buildPcmanrmInVM = runInLinuxVM (
    pcmanfm.overrideAttrs (old: {
      # goes out-of-memory with many cores
      enableParallelBuilding = false;
    })
  );

  testFedoraImage = makeImageTestScript diskImages.fedora42x86_64;
  testUbuntuImage = makeImageTestScript diskImages.ubuntu2404x86_64;
}
