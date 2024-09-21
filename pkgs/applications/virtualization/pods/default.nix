{ lib
, stdenv
, fetchFromGitHub
, cargo
, desktop-file-utils
, glib
, gtk4
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gtksourceview5
, libadwaita
, libpanel
, vte-gtk4
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CNMlBIIZbrczqtUYaIsu3T4dGJ7Qc5SNIgO1XIT0RGs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "podman-api-0.10.0" = "sha256-nbxK/U5G+PlbytpHdr63x/C69hBgedPXBFfgdzT9fdc=";
    };
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

  meta = with lib; {
    description = "Podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
    mainProgram = "pods";
  };
}
