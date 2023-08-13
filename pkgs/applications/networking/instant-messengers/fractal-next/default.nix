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
  version = "5.beta1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-i1kz7k2BBsSmZXUk6U2eT+08T2l950eFd67Cojtd1/k=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-0.6.2" = "sha256-27FYmqkzqh1wI6B2BI8LM4DoMfymyJdOn5OGsJZjBAc=";
      "ruma-0.8.2" = "sha256-Qsk8KVY5ix7nlDG+1246vQ5HZxgmJmm3KU+RknUFFGg=";
      "vodozemac-0.3.0" = "sha256-tAimsVD8SZmlVybb7HvRffwlNsfb7gLWGCplmwbLIVE=";
      "x25519-dalek-1.2.0" = "sha256-AHjhccCqacu0WMTFyxIret7ghJ2V+8wEAwR5L6Hy1KY=";
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
