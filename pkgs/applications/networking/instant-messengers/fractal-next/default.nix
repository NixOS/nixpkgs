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
  version = "unstable-2022-09-09";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = "5f0a4b48a745ccce202d14e7d02e14f51598fb42";
    hash = "sha256-7s2ytHpM5pZ0dhnVMA8KDWIBaSWds7t9GB6Wav+0dQA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-CJD9YmL06ELR3X/gIrsVCpDyJnWPbH/JF4HlXvWjiZ8=";
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

  meta = with lib; {
    description = "Matrix group messaging app (development version)";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler ]);
  };
}
