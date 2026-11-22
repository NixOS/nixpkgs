# Guest kernel for the anylinuxfs microVM, built from nohajc/libkrunfw: a fork
# of libkrunfw that only adds a kernel config, two patches and helper scripts.
#
# Upstream ships two kernels (16K and 4K pages) and a modules.squashfs with
# zfs/spl for the 16K one. We build the same things here.
{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  bc,
  bison,
  flex,
  perl,
  linuxManualConfig,
  linuxPackagesFor,
  squashfs-tools,
}:

let
  # Keep in sync with RELEASE_URL in anylinuxfs's download-dependencies.sh.
  version = "6.12.62-rev2";
  kernelVersion = lib.head (lib.splitString "-" version);

  fork = fetchFromGitHub {
    owner = "nohajc";
    repo = "libkrunfw";
    tag = "v${version}";
    hash = "sha256-h3oV4/NECJzyD/XpEhQL4g9/bpxo0elKJCkJqScJqw8=";
  };

  # Kernel sources with the fork's patches applied (what its Makefile does).
  # The list of patches lives in the fork, so apply them here instead of
  # listing them in kernelPatches, which would need import-from-derivation.
  src = stdenv.mkDerivation {
    pname = "linux-anylinuxfs-source";
    version = kernelVersion;

    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${kernelVersion}.tar.xz";
      hash = "sha256-E+LGhayPq13Zkt0QVzJVTa5RSu81DCqMdBjnt062LBM=";
    };

    # 0023 changes kernel_neon_begin/end from EXPORT_SYMBOL_GPL to EXPORT_SYMBOL
    # so the CDDL zfs module can use NEON. We skip it: OpenZFS detects the
    # GPL-only export and uses its non-NEON code instead, like
    # linuxPackages.zfs on aarch64 does.
    postPatch = ''
      for p in ${fork}/patches/0*.patch; do
        if [[ "$(basename "$p")" == 0023-fix-zfs-build.patch ]]; then
          echo "skipping $p"
          continue
        fi
        echo "applying $p"
        patch -p1 < "$p"
      done
    '';

    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  };

  # Upstream only commits the 16K config and makes the 4K one with menuconfig.
  # The config embedded in their Image-4K (CONFIG_IKCONFIG) differs from the
  # committed one only in page size and COMPAT, plus options that follow from
  # those, so we can recreate it.
  mkConfig =
    pageSize:
    stdenv.mkDerivation {
      pname = "linux-anylinuxfs-config-${pageSize}";
      version = kernelVersion;
      inherit src;

      nativeBuildInputs = [
        bc
        bison
        flex
        perl
      ];

      postPatch = ''
        patchShebangs scripts/config
      '';

      makeFlags = [ "ARCH=${stdenv.hostPlatform.linuxArch}" ];

      configurePhase = ''
        runHook preConfigure
        cp ${fork}/config-libkrunfw_aarch64 .config
      ''
      + lib.optionalString (pageSize == "4k") ''
        scripts/config \
          --disable ARM64_16K_PAGES \
          --enable ARM64_4K_PAGES \
          --disable COMPAT
      ''
      + ''
        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        make "''${makeFlags[@]}" olddefconfig
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp .config $out
        runHook postInstall
      '';
    };

  mkKernel =
    pageSize:
    (linuxManualConfig {
      pname = "linux-anylinuxfs-${pageSize}";
      version = kernelVersion;
      inherit src;
      modDirVersion = kernelVersion;
      configfile = mkConfig pageSize;
      config = {
        CONFIG_MODULES = "y";
      };
      buildDTBs = false;
    }).overrideAttrs
      (old: {
        postInstall =
          let
            from = "xargs -d'\\n' rm";
          in
          assert lib.assertMsg (lib.hasInfix from old.postInstall)
            "anylinuxfs guest kernel: build.nix no longer contains `${from}`, remove the workaround";
          lib.replaceStrings [ from ] [ "xargs -r -d'\\n' rm" ] old.postInstall;
      });

  kernel16k = mkKernel "16k";
  kernel4k = mkKernel "4k";

  # Like upstream, zfs is only built for the 16K kernel (the default one).
  # anylinuxfs only boots Image-4K for f2fs with 4K blocks or when asked to.
  zfs = (linuxPackagesFor kernel16k).zfs_2_4;
in
stdenv.mkDerivation {
  pname = "anylinuxfs-guest-kernel";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ squashfs-tools ];

  # init-rootfs unpacks modules.squashfs into /lib/modules/$(uname -r) in the
  # guest and runs depmod there.
  buildPhase = ''
    runHook preBuild

    mkdir -p modules/extra
    cp ${kernel16k.modules}/lib/modules/${kernelVersion}/modules.builtin{,.modinfo} modules/
    cp ${zfs}/lib/modules/${kernelVersion}/extra/{spl,zfs}.ko modules/extra/
    mksquashfs modules modules.squashfs -all-root -comp xz

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 ${kernel16k}/Image $out/Image
    install -Dm644 ${kernel4k}/Image $out/Image-4K
    install -Dm644 modules.squashfs -t $out
    runHook postInstall
  '';

  passthru = {
    inherit
      fork
      kernel16k
      kernel4k
      zfs
      ;
  };

  meta = {
    description = "Guest kernel and zfs modules for the anylinuxfs microVM";
    homepage = "https://github.com/nohajc/libkrunfw";
    license = with lib.licenses; [
      gpl2Only # kernel
      cddl # zfs
    ];
    platforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [ fractuscontext ];
  };
}
