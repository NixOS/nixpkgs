{ lib
, stdenv
, fetchgit
, acpica-tools
, python3
, writeText
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seabios";
  version = "1.16.3";

  src = fetchgit {
    url = "https://git.seabios.org/seabios.git";
    rev = "rel-${finalAttrs.version}";
    hash = "sha256-hWemj83cxdY8p+Jhkh5GcPvI0Sy5aKYZJCsKDjHTUUk=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ python3 ];

  buildInputs = [ acpica-tools ];

  strictDeps = true;

  makeFlags = [
    # https://www.seabios.org/Build_overview#Distribution_builds
    "EXTRAVERSION=\"-nixpkgs\""
  ];

  hardeningDisable = [ "pic" "stackprotector" "fortify" ];

  postConfigure = let
    config = writeText "config.txt" (lib.generators.toKeyValue { } {
      # SeaBIOS with CSM (Compatible Support Module) support; learn more at
      # https://www.electronicshub.org/what-is-csm-bios/
      "CONFIG_CSM" = "y";
      "CONFIG_PERMIT_UNALIGNED_PCIROM" = "y";
      "CONFIG_QEMU_HARDWARE" = "y";
    });
  in ''
    cp ${config} .config
    make olddefconfig
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $doc/share/doc/seabios-${finalAttrs.version}/
    cp -v docs/* $doc/share/doc/seabios-${finalAttrs.version}/
    install -Dm644 out/Csm16.bin -t $out/share/seabios/

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.seabios.org";
    description = "Open source implementation of a 16bit x86 BIOS";
    longDescription = ''
      SeaBIOS is an open source implementation of a 16bit x86 BIOS.
      It can run in an emulator or it can run natively on x86 hardware with the
      use of coreboot.
    '';
    license = with lib.licenses; [ lgpl3Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.systems.inspect.patternLogicalAnd
      lib.systems.inspect.patterns.isUnix
      lib.systems.inspect.patterns.isx86;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
})
