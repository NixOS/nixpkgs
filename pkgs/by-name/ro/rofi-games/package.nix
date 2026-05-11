{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  just,
  rofi,
  pkg-config,
  glib,
  cairo,
  pango,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-games";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "rofi-games";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LwzlBjRh9YdUGBl9+L3Vdetmy7lUdAIvjKvp8hSebvY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-opImhuLXj3/TtpmBjjMvrcdHalxYFyv5QZ0V8poYH7U=";
  };

  patches = [
    # fix the install locations of files and set default just task
    ./fix-justfile.patch
  ];

  env.PKGDIR = placeholder "out";

  strictDeps = true;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    just
    rofi
    pkg-config
  ];

  buildInputs = [
    glib
    cairo
    pango
    sqlite
  ];

  meta = {
    changelog = "https://github.com/Rolv-Apneseth/rofi-games/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Rofi plugin which adds a mode that will list available games for launch along with their box art";
    homepage = "https://github.com/Rolv-Apneseth/rofi-games";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
