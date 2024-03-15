{ lib
, blueprint-compiler
, cargo
, darwin
, desktop-file-utils
, fetchFromGitLab
, glib
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "switcheroo";
  version = "2.1.0";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Switcheroo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hopN2ynksaYoNYjXrh7plmhfmGYyqqK75GOtbsE95ZY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "switcheroo-${finalAttrs.version}";
    hash = "sha256-wN6MsiOgYFgzDzdGei0ptRbG+h+xMJiFfzCcg6Xtryw=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString
    (
      stdenv.cc.isClang &&
      lib.versionAtLeast stdenv.cc.version "16"
    )
    "-Wno-error=incompatible-function-pointer-types";

  meta = with lib; {
    changelog = "https://gitlab.com/adhami3310/Switcheroo/-/releases/v${finalAttrs.version}";
    description = "An app for converting images between different formats";
    homepage = "https://gitlab.com/adhami3310/Switcheroo";
    license = licenses.gpl3Plus;
    mainProgram = "switcheroo";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.unix;
  };
})
