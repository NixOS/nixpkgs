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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpwcenter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hxv5Xjlnv70Q/MGLZ4eTlhW8jYhx4gzhn3YL4oc4hN0=";
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
