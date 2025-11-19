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
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-APyQ4L05EHRbQFS1t7nXex4u+g9Sh8J70W80djOnmI4=";
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
