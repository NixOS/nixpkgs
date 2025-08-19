{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  openssl,
  pango,
  pipewire,
  sqlite,
  desktop-file-utils,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "euphonica";
  version = "0.96.1-beta";

  src = fetchFromGitHub {
    owner = "htkhiem";
    repo = "euphonica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MMrTabKE+zqVSmbjOg0NCsI47eSu1c73RnsPDgCbhCo=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zFGFmiPozfBSIYxCu4fHynb2eh9emfVPtj3grPAoZeA=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
    pipewire
    sqlite
    libxml2
  ];

  meta = {
    description = "MPD client with delusions of grandeur, made with Rust, GTK and Libadwaita";
    homepage = "https://github.com/htkhiem/euphonica";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "euphonica";
    platforms = with lib.platforms; linux;
  };
})
