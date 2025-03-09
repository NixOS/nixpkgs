{
  lib,
  stdenvNoCC,
  vmTools,
  fetchurl,
  runCommand,
}:
let
  debianSnapshot = "20250305T144614Z";

  debianArch =
    {
      "x86_64-linux" = "amd64";
      "aarch64-linux" = "arm64";
    }
    .${stdenvNoCC.hostPlatform.system};

  debClosureForArch =
    arch:
    vmTools.debClosureGenerator rec {
      name = "libguestfs-appliance-deb-closure-${arch}";
      packages = vmTools.commonDebianPackages ++ [
        "libguestfs-tools"
        "linux-image-${arch}" # required by supermin
        "qemu-utils"
      ];
      packagesLists = [
        (fetchurl {
          url = "${urlPrefix}/dists/testing/main/binary-${arch}/Packages.xz";
          hash =
            {
              "amd64" = "sha256-drhdsPvZhHpOwWh1G3NfhED3a8rBATI76ypEc4ZgJeM=";
              "arm64" = "sha256-jDC8SY8P7tnrwutaORdQ7DwfYSuhhhLD5fvH/TInKHk=";
            }
            .${arch};
        })
      ];
      urlPrefix = "https://snapshot.debian.org/archive/debian/${debianSnapshot}";
    };

  debClosures = runCommand "libguestfs-deb-closures" { } (
    lib.concatMapStringsSep "\n"
      (arch: "install -Dm444 ${debClosureForArch arch} $out/deb-closure-${arch}.nix")
      [
        "amd64"
        "arm64"
      ]
  );

  diskImage = vmTools.fillDiskWithDebs {
    name = "debian-testing-${debianArch}";
    fullName = "Debian testing (${debianArch})";
    debs =
      {
        amd64 = import ./deb-closure-amd64.nix { inherit fetchurl; };
        arm64 = import ./deb-closure-arm64.nix { inherit fetchurl; };
      }
      .${debianArch};
  };
in
vmTools.runInLinuxImage (
  stdenvNoCC.mkDerivation {
    pname = "libguestfs-appliance";
    # Since the appliance is built in a Debian guest, its version will be
    # the version of the libguestfs package in the Debian snapshot we're using.
    # When a new version of libguestfs lands in Debian testing, this package
    # can be updated as follows:
    # 1. Change the snapshot at the top of this file.
    # 2. Run `nix build .#libguestfs-appliance-debian.debClosures` and adjust
    #    the hashes accordingly.
    # 3. Copy the resulting .nix files to ./deb-closure-{amd64,arm64}.nix.
    # 4. Update the version number below to reflect the version number of
    #    libguestfs in the new Debian snapshot.
    version = "1.54.1";

    inherit diskImage;
    diskImageFormat = "qcow2";
    memSize = "2048"; # we need to be generous here

    dontUnpack = true;

    # libguestfs-make-fixed-appliance tests appliance it has built using QEMU,
    # which fails when using KVM due to a lack of support for nested KVM
    # virtualization. Therefore we have to force software virtualization.
    LIBGUESTFS_BACKEND_SETTINGS = "force_tcg";

    buildPhase = ''
      runHook preBuild

      libguestfs-make-fixed-appliance $out
      qemu-img convert -f raw -O qcow2 $out/root $out/root.qcow2
      mv $out/root.qcow2 $out/root

      runHook postBuild
    '';

    passthru = { inherit debClosures; };

    meta = {
      description = "Debian-based VM appliance disk image used in libguestfs package";
      homepage = "https://libguestfs.org";
      license = with lib.licenses; [
        gpl2Plus
        lgpl2Plus
      ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      maintainers = with lib.maintainers; [ malte-v ];
    };
  }
)
