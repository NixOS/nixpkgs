{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, rustPlatform
, pkg-config
, glib
, gtk4
, gtksourceview5
, libadwaita
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, libsecret
, desktop-file-utils
, appstream-glib
, openssl
, pipewire
, libshumate
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "fractal-next";
  version = "5-alpha1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-gHMfBGrq3HiGeqHx2knuc9LomgIW9QA9fCSCcQncvz0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "indexed_db_futures-0.2.3" = "sha256-yAG2gqMclkyQNfb+gG+YlPX46rKSKGAmagQqlcP6gr8=";
      "matrix-sdk-0.5.0" = "sha256-qti8NEl8nhGLclX3AjF5X+RLX8AH2CQw/Z+uL3wRMp4=";
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
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
    libsecret
    openssl
    pipewire
    libshumate
  ];

  # enables pipewire API deprecated in 0.3.64
  # fixes error caused by https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  env.NIX_CFLAGS_COMPILE = toString [ "-DPW_ENABLE_DEPRECATED" ];

  meta = with lib; {
    description = "Matrix group messaging app (development version)";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler ]);
    mainProgram = "fractal";
  };
}
