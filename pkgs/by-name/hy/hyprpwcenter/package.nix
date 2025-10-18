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
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpwcenter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpwcenter";
    tag = "v${finalAttrs.version}";
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

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A GUI Pipewire control center";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
    mainProgram = "hyprpwcenter";
  };
})
