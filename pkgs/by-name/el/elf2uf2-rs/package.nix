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
  version = "2.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-e0i8ecjfNZxQgX5kDU1T8yAGUl4J7mbgG+ueBFsyTNA=";
  };

  cargoHash = "sha256-+oByDYfC5yA4xzJdTAoji1S0LDc4w+pGhFPFHBgeL8A=";

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
