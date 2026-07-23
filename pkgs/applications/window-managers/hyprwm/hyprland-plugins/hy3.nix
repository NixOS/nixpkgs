{
  lib,
  cmake,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "hy3";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    tag = "hl${finalAttrs.version}";
    hash = "sha256-P3wwiIfqo89evW7xzI+wOI/qM1WPZBiiSmGNtBmYeVk=";
  };

  nativeBuildInputs = [ cmake ];

  dontStrip = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "hl(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/outfoxxed/hy3";
    description = "Hyprland plugin for an i3 / sway like manual tiling layout";
    license = lib.licenses.gpl3;
    inherit (hyprland.meta) platforms;
    maintainers = with lib.maintainers; [
      aacebedo
      johnrtitor
    ];
  };
})
