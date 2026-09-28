{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  buildPackages,
  mtools,
  openssl,
  perl,
  xorriso,
  xz,
  syslinux,

  embedScript ? null,
  enableDefaultPlatformTargets ? true,
  additionalTargets ? { },
  enableDefaultOptions ? true,
  additionalOptions ? [ ],
  firmwareBinary ? "ipxe.efirom",
}:

let
  inherit (lib)
    assertOneOf
    attrNames
    concatStringsSep
    escapeShellArgs
    flip
    last
    licenses
    maintainers
    mapAttrsToList
    optional
    optionalAttrs
    optionalString
    optionals
    platforms
    splitString
    uniqueStrings
    ;

  inherit (stdenv.hostPlatform)
    isAarch32
    isAarch64
    isx86
    isx86_64
    ;

  platformTarget = platform: optionalAttrs (enableDefaultPlatformTargets && platform);

  targets =
    platformTarget isx86_64 {
      "bin-x86_64-efi/ipxe.efi" = null;
      "bin-x86_64-efi/ipxe.efirom" = null;
      "bin-x86_64-efi/ipxe.usb" = "ipxe-efi.usb";
      "bin-x86_64-efi/snp.efi" = null;
    }
    // platformTarget isx86 {
      "bin/ipxe.dsk" = null;
      "bin/ipxe.usb" = null;
      "bin/ipxe.iso" = null;
      "bin/ipxe.lkrn" = null;
      "bin/undionly.kpxe" = null;
    }
    // platformTarget isAarch32 {
      "bin-arm32-efi/ipxe.efi" = null;
      "bin-arm32-efi/ipxe.efirom" = null;
      "bin-arm32-efi/ipxe.usb" = "ipxe-efi.usb";
      "bin-arm32-efi/snp.efi" = null;
    }
    // platformTarget isAarch64 {
      "bin-arm64-efi/ipxe.efi" = null;
      "bin-arm64-efi/ipxe.efirom" = null;
      "bin-arm64-efi/ipxe.usb" = "ipxe-efi.usb";
      "bin-arm64-efi/snp.efi" = null;
    }
    // additionalTargets;

  getTargets = flip mapAttrsToList targets;

  binaries = uniqueStrings (
    getTargets (from: to: if (isNull to) then last (splitString "/" from) else to)
  );

  options =
    optionals enableDefaultOptions [
      "PING_CMD"
      "IMAGE_TRUST_CMD"
      "DOWNLOAD_PROTO_HTTP"
      "DOWNLOAD_PROTO_HTTPS"
    ]
    ++ additionalOptions;
in

assert assertOneOf "When building iPXE, the 'firmwareBinary' parameter" firmwareBinary binaries;

stdenv.mkDerivation (finalAttrs: {
  pname = "ipxe";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "ipxe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O7jUpnP+wa9zBIEqYa7FQ9Zo1Ii1oVH10nlk+c4iHwg=";
  };

  patches = [
    # GCC 16 gains stronger analysis for unused variables and emits a warning
    # (made fatal by -Werror), so the usage of this variable is made
    # unconditional.
    (fetchpatch {
      name = "w89c840-unused-variable.patch";
      url = "https://github.com/ipxe/ipxe/commit/2d28657ef63217b9a1774605267d84f89d751441.patch";
      hash = "sha256-p1r1iDOJbss458LlmfpuIkk+6VqthDl0mcK/EfcCqS4=";
    })

    # GCC 16 adds a warning (made fatal by -Werror) for attributes that do not
    # apply. Since the regparm attribute only applies for i386, it is dropped
    # for x86_64.
    (fetchpatch {
      name = "x86_64-drop-regparm-attribute.patch";
      url = "https://github.com/ipxe/ipxe/commit/c18d0a23b634ae001ea877020c0236bfca1468e5.patch";
      hash = "sha256-spEIdyw30zYiYmhnvYQEVUrr/uMnFqJO/yLWnPb+QMc=";
    })
    (fetchpatch {
      name = "librm-regparm-attribute-only-for-i386.patch";
      url = "https://github.com/ipxe/ipxe/commit/be35d67a029485f461ce83cbeda15056a52cb069.patch";
      hash = "sha256-ki6gUPC6njGvu27RsD3f1L0m82NOKj9es0/o0jXCpqk=";
    })
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    mtools
    openssl
    perl
    xorriso
    xz
  ]
  ++ optional isx86 syslinux;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # Hardening is not possible due to assembler code.
  hardeningDisable = [
    "pic"
    "stackprotector"
  ];

  makeFlags = [
    "ECHO_E_BIN_ECHO=echo"
    "ECHO_E_BIN_ECHO_E=echo" # No /bin/echo here.
    "CROSS=${stdenv.cc.targetPrefix}"
  ]
  ++ optional (embedScript != null) "EMBED=${embedScript}";

  buildFlags = attrNames targets;

  # Calling syslinux on a FAT image isn't going to work on Aarch64.
  postPatch = optionalString isAarch64 ''
    substituteInPlace src/util/genfsimg --replace-fail "	syslinux " "	true "
  '';

  configurePhase = ''
    runHook preConfigure
    for opt in ${escapeShellArgs options}; do echo "#define $opt" >> src/config/general.h; done
    substituteInPlace src/Makefile.housekeeping --replace-fail '/bin/echo' echo
  ''
  + optionalString isx86 ''
    substituteInPlace src/util/genfsimg --replace-fail /usr/lib/syslinux ${syslinux}/share/syslinux
  ''
  + ''
    runHook postConfigure
  '';

  preBuild = "cd src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ${concatStringsSep "\n" (
      getTargets (from: to: if (isNull to) then "cp -v ${from} $out" else "cp -v ${from} $out/${to}")
    )}
  ''
  + optionalString isx86 ''
    # Some PXE constellations especially with dnsmasq are looking for the file with .0 ending
    # let's provide it as a symlink to be compatible in this case.
    ln -s undionly.kpxe $out/undionly.kpxe.0
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    firmware = "${finalAttrs.finalPackage}/${firmwareBinary}";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Network boot firmware";
    homepage = "https://ipxe.org/";
    changelog = "https://github.com/ipxe/ipxe/releases/tag/v${finalAttrs.version}";
    license = with licenses; [
      bsd2
      bsd3
      gpl2Only
      ubdlException
      isc
      mit
      mpl11
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sigmasquadron ];
  };
})
