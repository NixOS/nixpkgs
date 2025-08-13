{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "elf2uf2-rs";
  version = "2.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7RS2OC00tjsSBYFvg0/FQf1HN515FdrmCoKhJBu4fvI=";
  };

  cargoHash = "sha256-OiZGM/cfGwJA3uCg5sf3eo99BJXFoSzL/2k8AioQeyM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux udev;

  meta = with lib; {
    description = "Convert ELF files to UF2 for USB Flashing Bootloaders";
    mainProgram = "elf2uf2-rs";
    homepage = "https://github.com/JoNil/elf2uf2-rs";
    license = with licenses; [ bsd0 ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      polygon
      moni
    ];
  };
}
