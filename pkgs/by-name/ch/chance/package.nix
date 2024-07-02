{
  lib,
  blueprint-compiler,
  cairo,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pango,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chance";
  version = "4.0.0";

  src = fetchFromGitLab {
    owner = "zelikos";
    repo = "rollit";
    rev = finalAttrs.version;
    hash = "sha256-2lZ7iMHMFE1wTSlJj0mIUV62jO0NundYiOC8rdUJGkQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-7klyWhV9ih9OzJ9JYWLWGHSR9shBHQMBRN+03QuY7bg=";
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
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
  ];

  meta = {
    description = "Roll the dice";
    homepage = "https://gitlab.com/zelikos/rollit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Guanran928 ];
    mainProgram = "rollit";
    platforms = lib.platforms.all;
  };
})
