{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  appstream,
  appstream-glib,
  cargo,
  cmake,
  desktop-file-utils,
  dos2unix,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  libxml2,
  meson,
  ninja,
  pkg-config,
  poppler,
  python3,
  rustPlatform,
  rustc,
  shared-mime-info,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "rnote";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "flxzt";
    repo = "rnote";
    tag = "v${version}";
    hash = "sha256-YA2iqHqeh1uZsXSwyn4EWYAUXUgXvshNqSo6MS8U6ZQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-p5GrvzECinqCryvMNfSI8QZTXHnytI7jJqolkX76lOo=";
  };

  nativeBuildInputs = [
    appstream-glib # For appstream-util
    cmake
    desktop-file-utils # For update-desktop-database
    dos2unix
    meson
    ninja
    pkg-config
    python3 # For the postinstall script
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    shared-mime-info # For update-mime-database
    wrapGAppsHook4
  ];

  dontUseCmakeConfigure = true;

  mesonFlags = [
    (lib.mesonBool "cli" true)
  ];

  buildInputs = [
    appstream
    glib
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libxml2
    poppler
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  postPatch = ''
    chmod +x build-aux/*.py
    patchShebangs build-aux
  '';

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  meta = {
    homepage = "https://github.com/flxzt/rnote";
    changelog = "https://github.com/flxzt/rnote/releases/tag/${src.tag}";
    description = "Simple drawing application to create handwritten notes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      gepbird
      yrd
    ];
    platforms = lib.platforms.unix;
  };
}
