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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-fTETUD/OaOati5HvNxto5Cw26wMclt6mxPLm4cyE3+0=";
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
  NIX_CFLAGS_COMPILE = [ "-DPW_ENABLE_DEPRECATED" ];

  meta = with lib; {
    description = "Matrix group messaging app (development version)";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ anselmschueler ]);
    mainProgram = "fractal";
  };
}
