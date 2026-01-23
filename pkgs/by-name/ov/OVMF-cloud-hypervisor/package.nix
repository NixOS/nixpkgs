{
  stdenv,
  nixosTests,
  lib,
  edk2,
  util-linux,
  nasm,
  acpica-tools,
  llvmPackages,
  fetchFromGitLab,
  fdSize2MB ? false,
  fdSize4MB ? secureBoot,
  secureBoot ? false,
  systemManagementModeRequired ? secureBoot && stdenv.hostPlatform.isx86,
  httpSupport ? false,
  tpmSupport ? false,
  tlsSupport ? false,
  debug ? false,
  # Usually, this option is broken, do not use it except if you know what you are
  # doing.
  sourceDebug ? false,
  projectDscPath ?
    {
      x86_64 = "OvmfPkg/CloudHv/CloudHvX64.dsc";
      aarch64 = "ArmVirtPkg/ArmVirtCloudHv.dsc";
    }
    .${stdenv.hostPlatform.parsed.cpu.name}
      or (throw "Unsupported OVMF `projectDscPath` on ${stdenv.hostPlatform.parsed.cpu.name}"),
  fwPrefix ?
    {
      x86_64 = "CLOUDHV";
      aarch64 = "CLOUDHV_EFI";
    }
    .${stdenv.hostPlatform.parsed.cpu.name}
      or (throw "Unsupported OVMF `fwPrefix` on ${stdenv.hostPlatform.parsed.cpu.name}"),
}:

let
  cpuName = stdenv.hostPlatform.parsed.cpu.name;

  version = lib.getVersion edk2;

  OvmfPkKek1AppPrefix = "4e32566d-8e9e-4f52-81d3-5bb9715f9727";

  debian-edk-src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "qemu-team";
    repo = "edk2";
    nonConeMode = true;
    sparseCheckout = [
      "debian/edk2-vars-generator.py"
      "debian/python"
      "debian/PkKek-1-*.pem"
      "debian/patches/OvmfPkg-X64-add-opt-org.tianocore-UninstallMemAttrPr.patch"
    ];
    rev = "refs/tags/debian/2025.02-8";
    hash = "sha256-n/6T5UBwW8U49mYhITRZRgy2tNdipeU4ZgGGDu9OTkg=";
  };

  buildPrefix = "Build/*/*";

in

edk2.mkDerivation projectDscPath (finalAttrs: {
  pname = "OVMF";
  inherit version;

  outputs = [
    "out"
    "fd"
  ];

  nativeBuildInputs = [
    util-linux
    nasm
    acpica-tools
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.bintools
    llvmPackages.llvm
  ];

  strictDeps = true;

  hardeningDisable = [
    "format"
    "stackprotector"
    "pic"
    "fortify"
  ];

  buildFlags =
    # IPv6 has no reason to be disabled.
    [ "-D NETWORK_IP6_ENABLE=TRUE" ]
    ++ lib.optionals debug [ "-D DEBUG_ON_SERIAL_PORT=TRUE" ]
    ++ lib.optionals sourceDebug [ "-D SOURCE_DEBUG_ENABLE=TRUE" ]
    ++ lib.optionals secureBoot [ "-D SECURE_BOOT_ENABLE=TRUE" ]
    ++ lib.optionals systemManagementModeRequired [ "-D SMM_REQUIRE=TRUE" ]
    ++ lib.optionals fdSize2MB [ "-D FD_SIZE_2MB" ]
    ++ lib.optionals fdSize4MB [ "-D FD_SIZE_4MB" ]
    ++ lib.optionals httpSupport [
      "-D NETWORK_HTTP_ENABLE=TRUE"
      "-D NETWORK_HTTP_BOOT_ENABLE=TRUE"
    ]
    ++ lib.optionals tlsSupport [ "-D NETWORK_TLS_ENABLE=TRUE" ]
    ++ lib.optionals tpmSupport [
      "-D TPM_ENABLE"
      "-D TPM2_ENABLE"
      "-D TPM2_CONFIG_ENABLE"
    ];

  buildConfig = if debug then "DEBUG" else "RELEASE";
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Qunused-arguments";

  patches = [
    (debian-edk-src + "/debian/patches/OvmfPkg-X64-add-opt-org.tianocore-UninstallMemAttrPr.patch")
  ];

  postInstall = ''
    mkdir -vp $fd/FV
    mv -v $out/FV/${fwPrefix}.fd $fd/FV
  '';

  dontPatchELF = true;

  passthru =
    let
      prefix = "${finalAttrs.finalPackage.fd}/FV/${fwPrefix}";
    in
    {
      mergedFirmware = "${prefix}.fd";
      firmware = "${prefix}.fd";
      # This will test the EFI firmware for the host platform as part of the NixOS Tests setup.
      tests.basic-systemd-boot = nixosTests.systemd-boot.basic;
      tests.secureBoot-systemd-boot = nixosTests.systemd-boot.secureBoot;
      inherit secureBoot systemManagementModeRequired;
    };

  meta = {
    description = "Sample UEFI firmware for Cloud Hypervisor and KVM";
    homepage = "https://github.com/tianocore/tianocore.github.io/wiki/OVMF";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      messemar
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
