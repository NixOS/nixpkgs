{ stdenv
, lib
, fetchFromGitLab
, cargo
, meson
, ninja
, rustPlatform
, rustc
, pkg-config
, glib
, gtk4
, gtksourceview5
, libadwaita
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, desktop-file-utils
, appstream-glib
, openssl
, pipewire
, libshumate
, wrapGAppsHook4
, sqlite
, xdg-desktop-portal
}:

stdenv.mkDerivation rec {
  pname = "fractal-next";
  version = "5.beta2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-/BO+TlhLhi7BGsHq8aOpYw8AqNrJT0IJZOc1diq2Rys=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-0.6.2" = "sha256-A1oKNbEx2A6WwvYcNSW53Fd6QWwr0QFJtrsJXO2KInE=";
      "ruma-0.8.2" = "sha256-kCGS7ACFGgmtTUElLJQMYfjwJ3glF7bRPZYJIFcuPtc=";
      "curve25519-dalek-4.0.0" = "sha256-sxEFR6lsX7t4u/fhWd6wFMYETI2egPUbjMeBWkB289E=";
      "vodozemac-0.4.0" = "sha256-TCbWJ9bj/FV3ILWUTcksazel8ESTNTiDGL7kGlEGvow=";
    };
  };

  nativeBuildInputs = [
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gtk4
    gtksourceview5
    libadwaita
    openssl
    pipewire
    libshumate
    sqlite
    xdg-desktop-portal
  ];

  meta = with lib; {
    description = "Matrix group messaging app (development version)";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler ]);
    mainProgram = "fractal";
  };
}
