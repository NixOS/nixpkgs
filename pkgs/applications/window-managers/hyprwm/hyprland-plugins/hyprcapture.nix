{
  lib,
  cmake,
  qt6,
  kdePackages,
  nlohmann_json,
  fetchFromGitHub,
  hyprland,
  mkHyprlandPlugin,
  nix-update-script,
}:
mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprcapture";
  version = "0.2.1-0.55";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "HyprCapture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uqeDozWxRz7j/8sJ/EYr3rSmdkRFwl8bTKSVjvf942o=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qtbase
    qt6.qtdeclarative
    qt6.wrapQtAppsHook
    kdePackages.layer-shell-qt
    nlohmann_json
  ];

  postPatch = ''
    substituteInPlace src/plugin/session_launcher.cpp \
      --replace-fail 'const auto helper = firstRunnableHelper(request.defaults.helper);' \
                     'const std::optional<std::string> helper = std::string("${placeholder "out"}/bin/hyprcapture-ui");'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/gfhdhytghd/HyprCapture";
    description = "The best screenshot tool for Hyprland";
    license = lib.licenses.gpl3;
    inherit (hyprland.meta) platforms;
    maintainers = with lib.maintainers; [
      jonas-elhs
    ];
  };
})
