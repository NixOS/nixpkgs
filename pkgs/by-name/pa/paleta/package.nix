{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  glib,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation rec {
  pname = "paleta";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nate-xyz";
    repo = "paleta";
    rev = "v${version}";
    hash = "sha256-c+X49bMywstRg7cSAbbpG/vd8OUB7RhdQVRumTIBDDk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-RuzqU06iyK+IN7aO+Lq/IaRLh2oFpWM1rz69Koiicgg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Extract the dominant colors from any image";
    mainProgram = "paleta";
    homepage = "https://github.com/nate-xyz/paleta";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
