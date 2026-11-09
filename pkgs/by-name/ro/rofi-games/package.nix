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

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-games";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "rofi-games";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+2I4WR5SOLYSWnPUrJFlRwhnebu4RNy3Dd4/gKW8xXU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-dPm9+rxEtx32HVaXLrbxZiVyUrYwFPvuk/gRQR4Fo+s=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Rolv-Apneseth/rofi-games/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Rofi plugin which adds a mode that will list available games for launch along with their box art";
    homepage = "https://github.com/Rolv-Apneseth/rofi-games";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
