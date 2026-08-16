{
  lib,
  gcc16Stdenv,
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
  nix-update-script,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WGAG9f7YnEjAu33WWxL6kkOyZGgcpiASwdNxpkwr2AQ=";
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
  separateDebugInfo = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprutils";
    changelog = "https://github.com/hyprwm/hyprutils/releases/tag/${finalAttrs.src.tag}";
    description = "Small C++ library for utilities used across the Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    teams = [ lib.teams.hyprland ];
    maintainers = with lib.maintainers; [ logger ];
  };
})
