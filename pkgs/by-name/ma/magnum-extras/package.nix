{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  corrade,
  magnum,
  withUi ? true,
  withUiGallery ? true,
  withPlayer ? false,
}:

assert lib.assertMsg (
  !(withUi && !magnum.args.withGlxApplication)
) "magnum-extras: withUi=true requires magnum needs to be built with withGlxApplication=true";

assert lib.assertMsg (
  !(withUiGallery && !magnum.args.withGlxApplication)
) "magnum-extras: withUi=true requires magnum needs to be built with withGlxApplication=true";

stdenv.mkDerivation (finalAttrs: {
  pname = "magnum-extras";
  version = "2020.06-unstable-2026-10-07";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "mosra";
    repo = "magnum-extras";
    rev = "79fff8c401a577f4bb68de730929e2a9b556d251";
    hash = "sha256-mWHGVm6kOJjgMYGMcoD/iehbCtFr/6LMEkdB1ov1vfQ=";
  };

  nativeBuildInputs = [
    cmake
    corrade # Makes corrade-rc accessible during build
  ];
  propagatedBuildInputs = [
    magnum
  ];

  cmakeFlags = [
    (lib.cmakeBool "MAGNUM_BUILD_TESTS" true)
    (lib.cmakeBool "MAGNUM_WITH_PLAYER" withPlayer)
    # cmake_dependent_option(MAGNUM_WITH_UI "Build Ui library" OFF "NOT MAGNUM_WITH_PLAYER" ON)
    # cmake_dependent_option(MAGNUM_WITH_UI_GALLERY "Build magnum-ui-gallery executable" OFF "MAGNUM_WITH_UI" OFF)
    (lib.cmakeBool "MAGNUM_WITH_UI" withUi)
    (lib.cmakeBool "MAGNUM_WITH_UI_GALLERY" withUiGallery)
  ];

  doCheck = true;
  preCheck = ''
    # Needed for unit tests trying to use Alsa, which is not available in the sandbox
    export ALSOFT_DRIVERS=null
  '';

  meta = with lib; {
    description = "Extras for the Magnum C++11 graphics engine";
    homepage = "https://github.com/msora/magnum-extras";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
