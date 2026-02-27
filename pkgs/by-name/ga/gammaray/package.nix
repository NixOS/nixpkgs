{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  wayland,
  elfutils,
  libbfd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gammaray";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-CJKb7H77PjPwCGW4fqLSJw1mhSweuFYlDE/7RyVDcT0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    qt6.qtsvg
    qt6.qt3d
    qt6.qtdeclarative
    qt6.qtconnectivity
    qt6.qtlocation
    qt6.qtscxml
    qt6.qtwebengine
    kdePackages.kcoreaddons
    wayland
    elfutils
    libbfd
  ];

  cmakeFlags = [
    # FIXME: build failed when enable BUILD_DOCS with qtwayland in buildInputs
    "-DGAMMARAY_BUILD_DOCS=OFF"
  ];

  meta = {
    description = "Software introspection tool for Qt applications developed by KDAB";
    homepage = "https://github.com/KDAB/GammaRay";
    changelog = "https://github.com/KDAB/GammaRay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "gammaray";
  };
})
