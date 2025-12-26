{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  csxcad,
  tinyxml,
  vtkWithQt6,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qcsxcad";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "QCSXCAD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bX6e3ugHJynU9tP70BV8TadnoGg1VO7SAYJueMkMAyo=";
  };

  patches = [
    # ref. https://github.com/thliebig/QCSXCAD/pull/18 merged upstream
    (fetchpatch {
      name = "fix-cmake-40-issues.patch";
      url = "https://github.com/thliebig/QCSXCAD/commit/200c9c211ee1401d6dce2bcbf2543089cdc67208.patch";
      hash = "sha256-OVihvjBRTQ87l0bBq2J8aWC7WdFCPqy5CtU4S5a11Xw=";
    })
    (fetchpatch {
      name = "update-cmake-minimum-required.patch";
      url = "https://github.com/thliebig/QCSXCAD/commit/64a4bdc13511690499756e6602076c1e70cf4ee7.patch";
      hash = "sha256-rzVj9YdAJVxhTatTO5MxZJInb1RB0qqmPFAkI2nxpQ0=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RPATH" false)
  ];

  buildInputs = [
    csxcad
    tinyxml
    vtkWithQt6
    qt6.qtbase
    qt6.qt5compat
    qt6.qtwayland
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt library for CSXCAD";
    homepage = "https://github.com/thliebig/QCSXCAD";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
})
