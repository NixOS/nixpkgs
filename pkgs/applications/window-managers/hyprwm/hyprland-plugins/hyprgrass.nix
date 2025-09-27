{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  cmake,
  doctest,
  meson,
  ninja,
  wf-touch,
  nix-update-script,
}:

mkHyprlandPlugin {
  pluginName = "hyprgrass";
  version = "0.8.2-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "horriblename";
    repo = "hyprgrass";
    rev = "9b341353a91c23ced96e5ed996dda62fbe426a32";
    hash = "sha256-Nwd8JwGEEdGBJthxiopK51Fwva5TbM1PEOQDe+NAZEw=";
  };

  nativeBuildInputs = [
    cmake
    doctest
    meson
    ninja
  ];

  buildInputs = [ wf-touch ];

  dontUseCmakeConfigure = true;

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland plugin for touch gestures";
    homepage = "https://github.com/horriblename/hyprgrass";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
}
