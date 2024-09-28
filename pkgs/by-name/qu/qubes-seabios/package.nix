{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  seabios,
}:
let
  inherit (lib) concatStringsSep map;

  version = "4.2.0";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-seabios";
    rev = "refs/tags/R${version}";
    hash = "sha256-KEvdQ0VLJSnLRNuzMBWY0LFp9CN1EKq3K2v8Ud/vojc=";
  };
  mkBios = {
    config,
    target ? "",
    outBin,
    name,
  }: stdenv.mkDerivation {
    inherit version;
    src = seabios.src;
    pname = "qubes-seabios-${name}";

    nativeBuildInputs = [
      python3
    ];
    buildPhase = ''
      mkdir binaries

      cp ${src}/${config} .config
      make oldnoconfig
      make V=1 ${target}
    '';
    installPhase = ''
      mkdir $out
      ls out
      cp out/${outBin} $out/${name}
    '';
  };
  mkVgaBios = name: mkBios {config="config.vga-${name}"; outBin = "vgabios.bin"; name = "vgabios-${name}.bin"; target = "out/vgabios.bin";};
  # For me the build is breaking if trying to build all packages in the same derivation,
  # they are conflicting somehow. Building everything by itself, and then combining into a single dir.
  seabioses = concatStringsSep "," [
    (mkBios {config = "config.seabios-128k"; outBin = "bios.bin"; name = "bios.bin";})
    (mkBios {config = "config.seabios-256k"; outBin = "bios.bin"; name = "bios-256k.bin";})
    (mkBios {config = "config.csm"; outBin = "Csm16.bin"; name = "bios-csm.bin";})
    (mkBios {config = "config.coreboot"; outBin = "bios.bin.elf"; name = "bios-coreboot.bin";})
    (mkBios {config = "config.seabios-microvm"; outBin = "bios.bin"; name = "bios-microvm.bin";})
  ];
  # Probably we don't need all of those... Building for completeness.
  seavgabioses = concatStringsSep "," (map mkVgaBios ["bochs-display" "cirrus" "isavga" "qxl" "stdvga" "ramfb" "vmware" "virtio" "ati"]);

in
stdenvNoCC.mkDerivation {
  name = "qubes-seabios";
  inherit version;
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/share/{seabios,seavgabios}
    cp {${seabioses}}/*.bin $out/share/seabios
    cp {${seavgabioses}}/*.bin $out/share/seavgabios
  '';
}
