{
  lib,
  mkHyprlandPlugin,
  hyprland,
  fetchFromGitHub,
  cmake,
  doctest,
  meson,
  ninja,
  wf-touch,
  nix-update-script,
}:

mkHyprlandPlugin hyprland {
  pluginName = "hyprgrass";
  version = "0.8.2-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "horriblename";
    repo = "hyprgrass";
    rev = "dc19ccb209147312a4f60d76193b995c2634e756";
    hash = "sha256-3ALmrImk37KT+UHt1EMi6PAHyj8WhL9Xw/Ar/ys4rtk=";
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
