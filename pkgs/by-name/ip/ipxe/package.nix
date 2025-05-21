{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildPackages,
  mtools,
  openssl,
  perl,
  xorriso,
  xz,
  syslinux,
  embedScript ? null,
  additionalTargets ? { },
  additionalOptions ? [ ],
  firmwareBinary ? "ipxe.efirom",
}:

let
  targets =
    additionalTargets
    // lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
      "bin-x86_64-efi/ipxe.efi" = null;
      "bin-x86_64-efi/ipxe.efirom" = null;
      "bin-x86_64-efi/ipxe.usb" = "ipxe-efi.usb";
      "bin-x86_64-efi/snp.efi" = null;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isx86 {
      "bin/ipxe.dsk" = null;
      "bin/ipxe.usb" = null;
      "bin/ipxe.iso" = null;
      "bin/ipxe.lkrn" = null;
      "bin/undionly.kpxe" = null;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isAarch32 {
      "bin-arm32-efi/ipxe.efi" = null;
      "bin-arm32-efi/ipxe.efirom" = null;
      "bin-arm32-efi/ipxe.usb" = "ipxe-efi.usb";
      "bin-arm32-efi/snp.efi" = null;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
      "bin-arm64-efi/ipxe.efi" = null;
      "bin-arm64-efi/ipxe.efirom" = null;
      "bin-arm64-efi/ipxe.usb" = "ipxe-efi.usb";
      "bin-arm64-efi/snp.efi" = null;
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ipxe";
  version = "1.21.1-unstable-2025-05-16";

  nativeBuildInputs = [
    mtools
    openssl
    perl
    xorriso
    xz
  ] ++ lib.optional stdenv.hostPlatform.isx86 syslinux;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "ipxe";
    rev = "83449702e09236dccebd4913d5823d5e00b643e0";
    hash = "sha256-od4ZX0Tgc0S/b73jIvPmCEHNijlKDYJPjmOhoRmyNSM=";
  };

  # Calling syslinux on a FAT image isn't going to work on Aarch64.
  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace src/util/genfsimg --replace "	syslinux " "	true "
  '';

  # Hardening is not possible due to assembler code.
  hardeningDisable = [
    "pic"
    "stackprotector"
  ];

  makeFlags = [
    "ECHO_E_BIN_ECHO=echo"
    "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
    "CROSS=${stdenv.cc.targetPrefix}"
  ] ++ lib.optional (embedScript != null) "EMBED=${embedScript}";

  enabledOptions = [
    "PING_CMD"
    "IMAGE_TRUST_CMD"
    "DOWNLOAD_PROTO_HTTP"
    "DOWNLOAD_PROTO_HTTPS"
  ] ++ additionalOptions;

  configurePhase =
    ''
      runHook preConfigure
      for opt in ${lib.escapeShellArgs finalAttrs.enabledOptions}; do echo "#define $opt" >> src/config/general.h; done
      substituteInPlace src/Makefile.housekeeping --replace '/bin/echo' echo
    ''
    + lib.optionalString stdenv.hostPlatform.isx86 ''
      substituteInPlace src/util/genfsimg --replace /usr/lib/syslinux ${syslinux}/share/syslinux
    ''
    + ''
      runHook postConfigure
    '';

  preBuild = "cd src";

  buildFlags = lib.attrNames targets;

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          from: to: if to == null then "cp -v ${from} $out" else "cp -v ${from} $out/${to}"
        ) targets
      )}
    ''
    + lib.optionalString stdenv.hostPlatform.isx86 ''
      # Some PXE constellations especially with dnsmasq are looking for the file with .0 ending
      # let's provide it as a symlink to be compatible in this case.
      ln -s undionly.kpxe $out/undionly.kpxe.0
    ''
    + ''
      runHook postInstall
    '';

  enableParallelBuilding = true;

  passthru = {
    firmware = "${finalAttrs.finalPackage}/${firmwareBinary}";
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = {
    description = "Network boot firmware";
    homepage = "https://ipxe.org/";
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl2Only
      gpl2UBDLPlus
      isc
      mit
      mpl11
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sigmasquadron ];
  };
})
