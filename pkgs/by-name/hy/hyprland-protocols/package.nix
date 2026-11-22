{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-protocols";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g09dB6NCTzD4F6YgYrGXRhUfG52xwxUtlMAbHvv/1gE=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    changelog = "https://github.com/hyprwm/hyprland-protocols/releases/tag/${finalAttrs.src.tag}";
    description = "Wayland protocol extensions for Hyprland";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux;
  };
})
