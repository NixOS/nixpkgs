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
  version = "0.8.2-unstable-2024-10-30";

  src = fetchFromGitHub {
    owner = "horriblename";
    repo = "hyprgrass";
    rev = "f97b6ac2b7de3bae194b776c388467db2604929f";
    hash = "sha256-Jg5Q/v8tcNjopTMbra82y5n9QQdCnrbEFNgT1kA7pQE=";
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
