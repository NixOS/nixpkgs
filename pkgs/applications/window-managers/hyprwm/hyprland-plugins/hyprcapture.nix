{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  cmake,
  qt6,
  kdePackages,
  nlohmann_json,
  hyprland,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprcapture";
  version = "0.2.6-0.56.0";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "HyprCapture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3xTocd0xCYqSQAByjotOa8M2PscdGQFDIlkTp/kFRo=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtsvg
    kdePackages.layer-shell-qt
    nlohmann_json
  ];

  cmakeFlags = [
    "-DHYPRCAPTURE_DEFAULT_HELPER_PATH=${placeholder "out"}/bin/hyprcapture-ui"
    "-DHYPRCAPTURE_TRUSTED_BIN_DIRS=${hyprland}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland-only screenshot and recording tool";
    homepage = "https://github.com/gfhdhytghd/HyprCapture";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ anninzy ];
  };
})
