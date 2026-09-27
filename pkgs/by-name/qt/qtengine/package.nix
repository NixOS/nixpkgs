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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kossLAN";
    repo = "qtengine";
    tag = finalAttrs.version;
    hash = "sha256-9nhKFJ9AUxIS7wZ3be7Vxy36Q+4lgihB/RLooJ41niE=";
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
