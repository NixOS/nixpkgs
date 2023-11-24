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
  version = "5.rc1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-DtvTntPP//e0kT6JE/sOJk1U2su+CHHcrjcbgov1PYY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "matrix-sdk-0.6.2" = "sha256-X+4077rlaE8zjXHXPUfiYwa/+Bg0KTFrcsAg7yCz4ug=";
      "mas-http-0.5.0-rc.2" = "sha256-XH+I5URcbkSY4NDwfOFhIjb+/swuGz6n9hKufziPgoY=";
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
