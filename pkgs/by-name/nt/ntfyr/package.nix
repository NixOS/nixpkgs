{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  appstream,
  glib,
  gtk4,
  gtksourceview5,
  nix-update-script,
  blueprint-compiler,
  libadwaita,
  sqlite,
  appstream-glib,
}:
let
  pname = "ntfyr";

  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "tobagin";
    repo = "Ntfyr";
    tag = "v${version}";
    hash = "sha256-ZuBcHhcwP7posuAYhsWmhYWgXxZ+oLFtLTSj2NctVso=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ch4fKWH2dw1eGBvJcP6JOYu34DFLXXkbhju2KNDgHzw=";
  };

  nativeBuildInputs = [
    appstream
    appstream-glib
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
    gtksourceview5
    libadwaita
    sqlite
  ];

  passthru.updateScript = nix-update-script { };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Linux desktop client for ntfy.sh with GTK4";
    longDescription = ''
      Ntfyr is a native Linux client for ntfy.sh, providing desktop
      notifications via a GTK4 interface. It supports subscribing to
      ntfy.sh topics as well as self-hosted ntfy server instances.
    '';
    homepage = "https://github.com/tobagin/Ntfyr";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ joaqim ];
    mainProgram = "ntfyr";
    platforms = lib.platforms.linux;
  };
}
