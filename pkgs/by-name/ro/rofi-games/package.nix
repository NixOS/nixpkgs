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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-games";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "rofi-games";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-4L3gk/RG9g5QnUW1AJkZIl0VkBiO/L0HUBC3pibN/qo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    hash = "sha256-cU7gp/c1yx3ZLaZuGs1bvOV4AKgLusraILVJ2EhH1iA=";
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
  ];

  meta = {
    changelog = "https://github.com/Rolv-Apneseth/rofi-games/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Rofi plugin which adds a mode that will list available games for launch along with their box art";
    homepage = "https://github.com/Rolv-Apneseth/rofi-games";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
