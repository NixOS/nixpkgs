{
  stdenv,
  lib,
  fetchFromGitLab,
  cargo,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  gitMinimal,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  sqlite,
  wrapGAppsHook4,
  libglycin-gtk4,
  libshumate,
  libseccomp,
  libxml2,
  lcms2,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "shortwave";
  version = "5.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    hash = "sha256-MiaozChp5QF/Q0fCTCgnyGJLyIftTkMAbmfRQ/73QP8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-v6aphHunZrXPiuKRFT+EcWJySmQOOT433ST+m8j1z4w=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gitMinimal
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libglycin-gtk4
    openssl
    sqlite
    libshumate
    libseccomp
    libxml2
    lcms2
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/Shortwave";
    description = "Find and listen to internet radio stations";
    mainProgram = "shortwave";
    maintainers = with lib.maintainers; [ lasandell ];
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
