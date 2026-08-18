{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook4,

  rustPlatform,
  pkg-config,
  meson,
  ninja,
  cargo,
  rustc,

  cairo,
  gdk-pixbuf,
  gtk4,
  gtksourceview5,
  libadwaita,
  pango,
  sqlite,
  glib,
  openssl,
  libspelling,
  blueprint-compiler,
  desktop-file-utils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "reflection";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "p2panda";
    repo = "reflection";
    tag = finalAttrs.version;
    hash = "sha256-VPfYbMAyKv+2lWJ/TcQ7Em6kbutnJQIgbBTEqOnEDcc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3RR/YfJsq0eaRhaVVnocV5R1fbQ6YKsQ3QVZ1dc5HsI=";
  };

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    glib
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
    gtksourceview5
    libadwaita
    libspelling
    openssl
    pango
    sqlite
  ];

  meta = {
    description = "Collaborative, local-first GTK text editor";
    homepage = "https://github.com/p2panda/reflection";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "reflection";
    maintainers = with lib.maintainers; [ hougo ];
    teams = with lib.teams; [ ngi ];
  };
})
