{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  pixman,
  kdePackages,
  wayland-scanner,
  scdoc,
}:

let
  version = "0.0.7";
in
stdenv.mkDerivation {
  pname = "still";
  inherit version;

  src = fetchFromGitHub {
    owner = "faergeek";
    repo = "still";
    tag = "v${version}";
    hash = "sha256-tPDPEUBVfNNnTULRNuqyshfvjb1otiko3KlsAj46qRY=";
  };

  buildInputs = [
    pixman
    kdePackages.wayland
    kdePackages.wayland-protocols
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
    scdoc
  ];

  meta = {
    description = "Freeze the screen of a Wayland compositor until a provided command exits";
    license = lib.licenses.mit;
    homepage = "https://github.com/faergeek/still";
    changelog = "https://github.com/faergeek/still/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ bbenno ];
    mainProgram = "still";
    platforms = lib.platforms.linux;
  };
}
