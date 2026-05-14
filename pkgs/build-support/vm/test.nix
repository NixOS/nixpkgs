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

  # RPM-based distros
  testFedora42Image = makeImageTestScript diskImages.fedora42x86_64;
  testFedora43Image = makeImageTestScript diskImages.fedora43x86_64;
  testRocky9Image = makeImageTestScript diskImages.rocky9x86_64;
  testRocky10Image = makeImageTestScript diskImages.rocky10x86_64;
  testAlma9Image = makeImageTestScript diskImages.alma9x86_64;
  testAlma10Image = makeImageTestScript diskImages.alma10x86_64;
  testOracle9Image = makeImageTestScript diskImages.oracle9x86_64;
  testAmazon2023Image = makeImageTestScript diskImages.amazon2023x86_64;

  # Debian-based distros
  testDebian11i386Image = makeImageTestScript diskImages.debian11i386;
  testDebian11x86_64Image = makeImageTestScript diskImages.debian11x86_64;
  testDebian12i386Image = makeImageTestScript diskImages.debian12i386;
  testDebian12x86_64Image = makeImageTestScript diskImages.debian12x86_64;
  testDebian13i386Image = makeImageTestScript diskImages.debian13i386;
  testDebian13x86_64Image = makeImageTestScript diskImages.debian13x86_64;
  testUbuntu2204i386Image = makeImageTestScript diskImages.ubuntu2204i386;
  testUbuntu2204x86_64Image = makeImageTestScript diskImages.ubuntu2204x86_64;
  testUbuntu2404x86_64Image = makeImageTestScript diskImages.ubuntu2404x86_64;
}
