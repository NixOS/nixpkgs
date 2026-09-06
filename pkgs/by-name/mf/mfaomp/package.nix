{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libvlc,
  libvlcpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mfaomp";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Neurofibromin";
    repo = "mfaomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b8eIG5UC1i4yfHSStNwhgIttTS+g511RmFJ5OYxeYvM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwebengine
    qt6.qtsvg
    libvlc
    libvlcpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_PROVIDED_LIBVLCPP" true)
    (lib.cmakeBool "USE_FETCHED_LIBVLCPP" false)
  ];

  meta = {
    description = "Multiple Files At Once Media Player";
    homepage = "https://github.com/Neurofibromin/mfaomp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ neurofibromin ];
    platforms = lib.platforms.linux;
    mainProgram = "mfaomp";
  };
})
