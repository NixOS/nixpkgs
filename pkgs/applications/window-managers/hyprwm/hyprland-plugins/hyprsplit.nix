{
  lib,
  meson,
  fetchFromGitHub,
  hyprland,
  ninja,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin hyprland rec {
  pluginName = "hyprsplit";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "shezdy";
    repo = "hyprsplit";
    rev = "refs/tags/v${version}";
    hash = "sha256-0jrsiUoQi/VXM2Ji7YTOEYDYYlBI2C3ZbgQpYoAEVKI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/shezdy/hyprsplit";
    description = "Hyprland plugin for awesome / dwm like workspaces";
    license = lib.licenses.bsd3;
    inherit (hyprland.meta) platforms;
    maintainers = with lib.maintainers; [
      aacebedo
    ];
  };
}
