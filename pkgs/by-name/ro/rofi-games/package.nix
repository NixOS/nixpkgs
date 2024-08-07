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
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "rofi-games";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+NxSiEjfNMmhKRsaqyDa2JkviyKPy83A/vxkcfaZunE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    inherit (finalAttrs) src;
    hash = "sha256-6CakI7Gg4cJAEc+uxUvmMgZHjWuiBOhjbzwbzbf9ils=";
  };

  patches = [
    # fix the install locations of files and set default just task
    ./fix-justfile.patch
  ];

  env.PKGDIR = placeholder "out";

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
    description = "A rofi plugin which adds a mode that will list available games for launch along with their box art";
    homepage = "https://github.com/Rolv-Apneseth/rofi-games";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
