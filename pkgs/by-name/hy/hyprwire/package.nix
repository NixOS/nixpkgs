{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
  libffi,
  pugixml,
  wayland,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwire";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwire";
    rev = "v${finalAttrs.version}";
    hash = "sha256-84KqFPakU1Pv7axkwbSi1D5XssSHIW8B2xduOUq5Mw4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pugixml
    hyprutils
    libffi
  ];

  meta = with lib; {
    inherit (finalAttrs.src.meta) homepage;
    description = "A fast and consistent wire protocol for IPC ";
    license = licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    inherit (wayland.meta) platforms;
    broken = gcc15Stdenv.hostPlatform.isDarwin;
    mainProgram = "hyprwire";
  };
})
