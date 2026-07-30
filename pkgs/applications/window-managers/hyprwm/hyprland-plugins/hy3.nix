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
  version = "0.56.0.1";

  src = fetchFromGitHub {
    owner = "outfoxxed";
    repo = "hy3";
    tag = "hl${finalAttrs.version}";
    hash = "sha256-iK0vERuy5aXisDXm/bzcJP0dgaIot5MLPoVG62DjqO4=";
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
