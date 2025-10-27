{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  aquamarine,
  cairo,
  hyprgraphics,
  hyprlang,
  hyprtoolkit,
  hyprutils,
  hyprwire,
  libdrm,
  libqalculate,
  libxkbcommon,
  pixman,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlauncher";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6JVor77g1LR/22lZYCArUm/geIXE0aGJZ4DHIlgSOj4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    aquamarine
    cairo
    hyprgraphics
    hyprlang
    hyprtoolkit
    hyprutils
    hyprwire
    libdrm
    libqalculate
    libxkbcommon
    pixman
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A multipurpose and versatile launcher / picker for Hyprland";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
    mainProgram = "hyprlauncher";
  };
})
