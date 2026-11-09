{
  hello,
  patchelf,
  pcmanfm,
  releaseTools,
  runCommand,
  stdenv,
  vmTools,
}:
let
  inherit (vmTools)
    diskImageFuns
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

      diskImage = diskImages.fedora44x86_64;
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

  # Sanity check to ensure the dpkg --install commands have run
  checkPerlInstalledInDebian = runInLinuxImage (
    runCommand "check-perl"
      {
        diskImage = diskImages.debian13x86_64;
        diskImageFormat = "qcow2";
        memSize = 512;
      }
      ''
        echo Check if perl is present
        perl -v
        echo Check if perl is installed
        dpkg -l | grep 'ii *perl'
        mkdir $out
      ''
  );

  # A package that still ships ./bin/ must leave the /bin -> usr/bin symlink
  # alone, and every package's maintainer scripts have to have run.
  checkMergedUsrInUbuntu = runInLinuxImage (
    runCommand "check-merged-usr"
      {
        diskImage = diskImageFuns.ubuntu2404x86_64 { extraPackages = [ "busybox-static" ]; };
        diskImageFormat = "qcow2";
        memSize = 512;
      }
      ''
        test -L /bin
        /bin/sh -c true
        audit=$(dpkg --audit)
        if [ -n "$audit" ]; then
          echo "$audit" >&2
          exit 1
        fi
        mkdir $out
      ''
  );

  # The .deb has to hold what `make install` installed, and nothing it merely ran.
  buildHelloDebInDebian = releaseTools.debBuild {
    name = "hello";
    inherit (hello) src;
    diskImage = diskImages.debian13x86_64;
    diskImageFormat = "qcow2";
    meta.description = "GNU hello, built as a .deb";
    debName = "gnu-hello";
    debMaintainer = "Nixpkgs <nixpkgs@example.org>";
    postInstall = ''
      test "$(dpkg-deb --field $out/debs/*.deb Package)" = gnu-hello
      test "$(dpkg-deb --field $out/debs/*.deb Maintainer)" = "Nixpkgs <nixpkgs@example.org>"
      dpkg-deb --contents $out/debs/*.deb > contents
      grep -q '\./usr/bin/hello$' contents
      if grep '\./nix/' contents; then
        echo "the package picked up store paths" >&2
        exit 1
      fi
    '';
  };

  # RPM-based distros
  testFedora43Image = makeImageTestScript diskImages.fedora43x86_64;
  testFedora44Image = makeImageTestScript diskImages.fedora44x86_64;
  testRocky9Image = makeImageTestScript diskImages.rocky9x86_64;
  testRocky10Image = makeImageTestScript diskImages.rocky10x86_64;
  testAlma9Image = makeImageTestScript diskImages.alma9x86_64;
  testAlma10Image = makeImageTestScript diskImages.alma10x86_64;
  testOracle9Image = makeImageTestScript diskImages.oracle9x86_64;
  testOracle10Image = makeImageTestScript diskImages.oracle10x86_64;
  testAmazon2023Image = makeImageTestScript diskImages.amazon2023x86_64;

  # Debian-based distros
  testDebian12i386Image = makeImageTestScript diskImages.debian12i386;
  testDebian12x86_64Image = makeImageTestScript diskImages.debian12x86_64;
  testDebian13i386Image = makeImageTestScript diskImages.debian13i386;
  testDebian13x86_64Image = makeImageTestScript diskImages.debian13x86_64;
  testUbuntu2204i386Image = makeImageTestScript diskImages.ubuntu2204i386;
  testUbuntu2204x86_64Image = makeImageTestScript diskImages.ubuntu2204x86_64;
  testUbuntu2404x86_64Image = makeImageTestScript diskImages.ubuntu2404x86_64;
  testUbuntu2604x86_64Image = makeImageTestScript diskImages.ubuntu2604x86_64;
}
