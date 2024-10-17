{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-panel-colorizer";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-colorizer";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-O+qIsYF0E+9LeiDcOUh8pZVY1rVoMlniju6yLact2Bc=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.plasma-desktop
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_PLASMOID" true)
    (lib.cmakeBool "BUILD_PLUGIN" true)
    (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Fully-featured widget to bring Latte-Dock and WM status bar customization features to the default KDE Plasma panel";
    homepage = "https://github.com/luisbocanegra/plasma-panel-colorizer";
    changelog = "https://github.com/luisbocanegra/plasma-panel-colorizer/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
