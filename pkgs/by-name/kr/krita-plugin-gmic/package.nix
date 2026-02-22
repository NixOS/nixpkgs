{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  fftw,
  krita-unwrapped,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krita-plugin-gmic";
  version = "3.6.4.1";

  src = fetchurl {
    url = "https://files.kde.org/krita/build/dependencies/gmic-${finalAttrs.version}.tar.gz";
    hash = "sha256-prbGkwFWC+LqK1WDqOwZvX5Q5LQal3dFUXzpILwF+v4=";
  };
  sourceRoot = "gmic-v${finalAttrs.version}/gmic-qt";
  dontWrapQtApps = true;

  postPatch = ''
    patchShebangs \
      translations/filters/csv2ts.sh \
      translations/lrelease.sh
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    libsForQt5.qttools
  ];

  buildInputs = [
    fftw
    krita-unwrapped
    libsForQt5.kcoreaddons
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeFeature "GMIC_QT_HOST" "krita-plugin")
    # build krita's gmic instead of using the one from nixpkgs
    (lib.cmakeBool "ENABLE_SYSTEM_GMIC" false)
  ];

  meta = {
    homepage = "https://krita.org";
    description = "GMic plugin for Krita";
    license = lib.licenses.cecill21;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
})
