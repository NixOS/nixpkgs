{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprlang,
  hyprtoolkit,
  libxkbcommon,
  nix-update-script,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-guiutils";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-guiutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ee78BRFi+MrmgHmmW+2dZUEI1R3cssEzza0ar3fsNX8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprlang
    hyprtoolkit
    libxkbcommon
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland GUI utilities (successor to hyprland-qtutils)";
    homepage = "https://github.com/hyprwm/hyprland-guiutils";
    changelog = "https://github.com/hyprwm/hyprland-guiutils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
  };
})
