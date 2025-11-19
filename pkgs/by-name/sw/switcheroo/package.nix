{
  lib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  gtk4,
  imagemagick,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "switcheroo";
  version = "2.4.0";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Switcheroo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wzMN5oHc9xRrFVT+Y8sXcctSYAfJhGE7B07oOc6VUZM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-v7cl4SbQut6ZGmsHDbfV6ccE0A31TCej203S13q9Rco=";
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
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ imagemagick ]}"
    )
  '';

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://gitlab.com/adhami3310/Switcheroo/-/releases/v${finalAttrs.version}";
    description = "App for converting images between different formats";
    homepage = "https://apps.gnome.org/Converter/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "switcheroo";
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.unix;
  };
})
