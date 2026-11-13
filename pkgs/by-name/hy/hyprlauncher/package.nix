{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprlang,
  hyprtoolkit,
  hyprwire,
  libdrm,
  libqalculate,
  libxkbcommon,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlauncher";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sle245RO67pPNFd7IdvGHluB3bFqoFZlbIgYxrG3AZ0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprlang
    hyprtoolkit
    hyprwire
    libdrm
    libqalculate
    libxkbcommon
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
