{
  lib,
  stdenv,
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FWB9Xe9iIMlUskfLzKlYH3scvnHpSC5rMyN1EDHUQmE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeBuildType = "RelWithDebInfo";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprutils";
    description = "Small C++ library for utilities used across the Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    teams = [ lib.teams.hyprland ];
  };
})
