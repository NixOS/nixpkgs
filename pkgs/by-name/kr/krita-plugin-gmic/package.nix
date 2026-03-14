{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  fftw,
  krita-unwrapped,
  kdePackages,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krita-plugin-gmic";
  version = "3.6.6.2";

  src = fetchFromGitHub {
    owner = "vanyossi";
    repo = "gmic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YvTVzH5IpjMFo8WxiK0MtwRiN947cnLO/sbmOtZY404=";
  };

  sourceRoot = "${finalAttrs.src.name}/gmic-qt";
  dontWrapQtApps = true;

  postPatch = ''
    patchShebangs \
      translations/filters/csv2ts.sh \
      translations/lrelease.sh
  '';

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    curl
    fftw
    krita-unwrapped
    kdePackages.kcoreaddons
    qt6.qtbase
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
