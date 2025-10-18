{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  aquamarine,
  cairo,
  hyprgraphics,
  hyprtoolkit,
  hyprutils,
  libdrm,
  pipewire,
  pixman,
  wayland,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpwcenter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpwcenter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/kE3VlkJjpFxjbgdKCFumg/Oxn4n7Z//5atAObpPiRY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    aquamarine
    cairo
    hyprgraphics
    hyprtoolkit
    hyprutils
    libdrm
    pipewire
    pixman
  ];

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A GUI Pipewire control center";
    license = licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    inherit (wayland.meta) platforms;
    broken = gcc15Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprpwcenter";
  };
})
