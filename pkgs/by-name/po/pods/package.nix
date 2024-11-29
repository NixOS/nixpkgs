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
  version = "2.0.1-unstable-2024-08-11";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "146a85b4860375ac0a5be8d7be57fb12753a3c42";
    sha256 = "sha256-KaS38XC+V3jRPPTnI4UqMc9KGAC7INHMu47LVo9YP44=";
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
