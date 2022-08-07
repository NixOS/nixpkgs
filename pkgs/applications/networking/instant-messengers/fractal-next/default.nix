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
  version = "unstable-2022-07-10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = "837b56978474fe512469805844b8ee234587499a";
    hash = "sha256-6op/+eiDra5EFRludpkQOucBXdPl5a/oQWPwwhJEx+M=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-2mE26ES+fYSWdfMr8uTsX2VVGTNMDQ9MXEk5E/L95UI=";
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
