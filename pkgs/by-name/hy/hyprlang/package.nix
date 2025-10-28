{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pyDe001L3a1dQiUun25y2z4R8vOgx0cmo9l1SvWKEyA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprutils
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "Official implementation library for the hypr config language";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.hyprland ];
  };
})
