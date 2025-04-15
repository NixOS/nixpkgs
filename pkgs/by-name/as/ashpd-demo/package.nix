{
  lib,
  stdenv,
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

let
  libadwaita' = libadwaita.overrideAttrs (oldAttrs: {
    version = "1.6.2-unstable-2025-01-02";
    src = oldAttrs.src.override {
      tag = null;
      rev = "f5f0e7ce69405846a8f8bdad11cef2e2a7e99010";
      hash = "sha256-n5RbGHtt2g627T/Tg8m3PjYIl9wfYTIcrplq1pdKAXk=";
    };

    # `test-application-window` is flaky on aarch64-linux
    doCheck = false;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ashpd-demo";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "ashpd";
    tag = "${finalAttrs.version}";
    hash = "sha256-zWxkI5Cq+taIkJ27qsVMslcFr6EqfxstQm9YvvSj3so=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/ashpd-demo";
    hash = "sha256-eGFz3wWXXLhDesVU9yqj/fAX46RN6FxHFqhKwvr4C24=";
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
    pipewire
    wayland
    libshumate
    libadwaita'
  ];

  postPatch = ''
    cd ashpd-demo
  '';

  meta = {
    description = "Tool for playing with XDG desktop portals";
    mainProgram = "ashpd-demo";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.linux;
  };
})
