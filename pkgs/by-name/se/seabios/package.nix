{
  lib,
  acpica-tools,
  fetchgit,
  python3,
  stdenv,
  writeText,
  # Configurable options
  ___build-type ? "csm",
}:

assert lib.elem ___build-type [
  "coreboot"
  # SeaBIOS with CSM (Compatible Support Module) support; learn more at
  # https://www.electronicshub.org/what-is-csm-bios/
  "csm"
  "qemu"
];
let
  biosfile =
    {
      "coreboot" = "bios.bin.elf";
      "csm" = "Csm16.bin";
      "qemu" = "bios.bin";
    }
    .${___build-type};
  configuration-string =
    {
      "coreboot" = "CONFIG_COREBOOT";
      "csm" = "CONFIG_CSM";
      "qemu" = "CONFIG_QEMU";
    }
    .${___build-type};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "seabios";
  version = "1.16.3";

  src = fetchgit {
    url = "https://git.seabios.org/seabios.git";
    rev = "rel-${finalAttrs.version}";
    hash = "sha256-hWemj83cxdY8p+Jhkh5GcPvI0Sy5aKYZJCsKDjHTUUk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [ python3 ];

  buildInputs = [ acpica-tools ];

  strictDeps = true;

  makeFlags = [
    # https://www.seabios.org/Build_overview#Distribution_builds
    "EXTRAVERSION=\"-nixpkgs\""
  ];

  hardeningDisable = [
    "fortify"
    "pic"
    "stackprotector"
  ];

  postConfigure =
    let
      config = writeText "config.txt" (
        lib.generators.toKeyValue { } {
          "${configuration-string}" = "y";
          "CONFIG_PERMIT_UNALIGNED_PCIROM" = "y";
          "CONFIG_QEMU_HARDWARE" = "y";
        }
      );
    in
    ''
      cp ${config} .config
      make olddefconfig
    '';

  installPhase = ''
    runHook preInstall

    mkdir -pv ''${!outputDoc}/share/doc/seabios-${finalAttrs.version}/
    cp -v docs/* ''${!outputDoc}/share/doc/seabios-${finalAttrs.version}/
    install -Dm644 out/${biosfile} -t $out/share/seabios/

    runHook postInstall
  '';

  passthru = {
    build-type = ___build-type;
    firmware = "${finalAttrs.finalPackage}/share/seabios/${biosfile}";
  };

  meta = {
    homepage = "https://www.seabios.org";
    description = "Open source implementation of a 16bit x86 BIOS";
    longDescription = ''
      SeaBIOS is an open source implementation of a 16bit x86 BIOS.
      It can run in an emulator or it can run natively on x86 hardware with the
      use of coreboot.
    '';
    license = with lib.licenses; [ lgpl3Plus ];
    maintainers = with lib.maintainers; [ sigmasquadron ];
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isUnix lib.systems.inspect.patterns.isx86;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
})
