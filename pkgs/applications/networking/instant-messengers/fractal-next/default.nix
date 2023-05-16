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
<<<<<<< HEAD
=======
, libsecret
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, desktop-file-utils
, appstream-glib
, openssl
, pipewire
, libshumate
, wrapGAppsHook4
<<<<<<< HEAD
, sqlite
, xdg-desktop-portal
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "fractal-next";
<<<<<<< HEAD
  version = "5.beta2";
=======
  version = "5-alpha1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-/BO+TlhLhi7BGsHq8aOpYw8AqNrJT0IJZOc1diq2Rys=";
=======
    hash = "sha256-gHMfBGrq3HiGeqHx2knuc9LomgIW9QA9fCSCcQncvz0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "matrix-sdk-0.6.2" = "sha256-A1oKNbEx2A6WwvYcNSW53Fd6QWwr0QFJtrsJXO2KInE=";
      "ruma-0.8.2" = "sha256-kCGS7ACFGgmtTUElLJQMYfjwJ3glF7bRPZYJIFcuPtc=";
      "curve25519-dalek-4.0.0" = "sha256-sxEFR6lsX7t4u/fhWd6wFMYETI2egPUbjMeBWkB289E=";
      "vodozemac-0.4.0" = "sha256-TCbWJ9bj/FV3ILWUTcksazel8ESTNTiDGL7kGlEGvow=";
=======
      "indexed_db_futures-0.2.3" = "sha256-yAG2gqMclkyQNfb+gG+YlPX46rKSKGAmagQqlcP6gr8=";
      "matrix-sdk-0.5.0" = "sha256-qti8NEl8nhGLclX3AjF5X+RLX8AH2CQw/Z+uL3wRMp4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    openssl
    pipewire
    libshumate
    sqlite
    xdg-desktop-portal
  ];

=======
    libsecret
    openssl
    pipewire
    libshumate
  ];

  # enables pipewire API deprecated in 0.3.64
  # fixes error caused by https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  env.NIX_CFLAGS_COMPILE = toString [ "-DPW_ENABLE_DEPRECATED" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Matrix group messaging app (development version)";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler ]);
    mainProgram = "fractal";
  };
}
