{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
  libffi,
  pugixml,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwire";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-INI9AVrQG5nJZFvGPSiUZ9FEUZJLfGdsqjF1QSak7Gc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprutils
    libffi
    pugixml
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A fast and consistent wire protocol for IPC ";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
    mainProgram = "hyprwire";
  };
})
