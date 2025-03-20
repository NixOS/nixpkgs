{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  libshumate,
  gst_all_1,
  gtk4,
  libadwaita,
  pipewire,
  wayland,
  wrapGAppsHook4,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashpd-demo";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "ashpd";
    rev = "${finalAttrs.version}-demo";
    hash = "sha256-fIyJEUcyTcjTbBycjuJb99wALQelMT7Zq6PHKcL2F80=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/ashpd-demo";
    hash = "sha256-iluV24uSEHDcYi6pO2HNrKs4ShwFvZ/ryv8ioopaNMI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    rustPlatform.bindgenHook
    desktop-file-utils
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    glib
    gtk4
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libadwaita
    pipewire
    wayland
    libshumate
  ];

  postPatch = ''
    cd ashpd-demo
  '';

  meta = with lib; {
    description = "Tool for playing with XDG desktop portals";
    mainProgram = "ashpd-demo";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
})
