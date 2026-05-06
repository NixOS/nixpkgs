{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  cmake,
  SDL,
  python3,
  catch2_3,
  callPackage,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfxr-qt";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "agateau";
    repo = "sfxr-qt";
    rev = finalAttrs.version;
    hash = "sha256-JAWDk7mGkPtQ5yaA6UT9hlAy770MHrTBhBP9G8UqFKg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.extra-cmake-modules
    (python3.withPackages (
      pp: with pp; [
        pyyaml
        jinja2
        setuptools
      ]
    ))
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtquickcontrols2
    SDL
  ];

  checkInputs = [
    catch2_3
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_CATCH2" true)
  ];

  doCheck = true;

  passthru.tests = {
    export-square-wave = callPackage ./test-export-square-wave { };
    sfxr-qt-starts = nixosTests.sfxr-qt;
  };

  meta = {
    homepage = "https://github.com/agateau/sfxr-qt";
    description = "Sound effect generator, QtQuick port of sfxr";
    mainProgram = "sfxr-qt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.linux;
  };
})
