{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  desktop-file-utils,
  glib,
  gtk4,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  libpanel,
  vte-gtk4,
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = "pods";
    tag = "v${version}";
    hash = "sha256-S84Qb+hySjIxcznuA7Sh8n9XFvdZpf32Yznb1Sj+owY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-UBInZdoluWXq1jm2rhS5wBwXQ/zYFPSEeWhpSmkc2aY=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  meta = {
    description = "Podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ figsoda ];
    platforms = lib.platforms.linux;
    mainProgram = "pods";
  };
}
