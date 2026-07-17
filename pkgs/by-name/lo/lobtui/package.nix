{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lobtui";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "lobtui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ig/KdCuQZYSiCydouN29IsIRKh8qngtzcOknTozDRRM=";
  };

  cargoHash = "sha256-Cj6hf/dizIv2pKbQvyRqqIz5k3AW3cdfpCaIHvk8G9o=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "TUI for lobste.rs website";
    homepage = "https://github.com/pythops/lobtui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "lobtui";
    platforms = lib.platforms.linux;
  };
})
