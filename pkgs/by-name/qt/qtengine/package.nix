{
  lib,
  stdenv,
  cmake,
  ninja,
  kdePackages,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qtengine";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kossLAN";
    repo = "qtengine";
    tag = finalAttrs.version;
    hash = "sha256-aJ5ZdIX10nmhzMLjP6QMuFJHvljJD+xcojuKZjPkr70=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.kconfig
    kdePackages.kcolorscheme
    kdePackages.kiconthemes
  ];

  cmakeFlags = [
    "-DQT6_PLUGINDIR=${placeholder "out"}/${kdePackages.qtbase.qtPluginPrefix}"
    "-DBUILD_QT5=OFF"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Minimal Qt platform theme";
    homepage = "https://github.com/kossLAN/qtengine";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kosslan ];
  };
})
