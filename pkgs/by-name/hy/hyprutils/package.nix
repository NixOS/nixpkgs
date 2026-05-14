{
  lib,
  gcc15Stdenv,
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
  nix-update-script,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jAcsogZwWMfXT9MfXxZzkwliAqIuZUV0p71h6Ba9ReE=";
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
    maintainers = with lib.maintainers; [ logger ];
  };
})
