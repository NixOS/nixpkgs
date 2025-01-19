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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-c+X49bMywstRg7cSAbbpG/vd8OUB7RhdQVRumTIBDDk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2/ZfKvlvAY4pfUU3F9pEw+OR5oRSsSAAi3/W5x4zVs0=";
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

  meta = {
    description = "Extract the dominant colors from any image";
    mainProgram = "paleta";
    homepage = "https://github.com/nate-xyz/paleta";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
