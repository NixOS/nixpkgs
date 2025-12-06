{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  qtbase,
  qtquickcontrols2,
  SDL,
  python3,
  catch2,
  callPackage,
  nixosTests,
}:

mkDerivation rec {
  pname = "sfxr-qt";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "agateau";
    repo = "sfxr-qt";
    rev = version;
    hash = "sha256-JAWDk7mGkPtQ5yaA6UT9hlAy770MHrTBhBP9G8UqFKg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    (python3.withPackages (
      pp: with pp; [
        pyyaml
        jinja2
        setuptools
      ]
    ))
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    SDL
  ];

  checkInputs = [
    catch2
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_CATCH2" true)
  ];

  doCheck = true;

  passthru.tests = {
    export-square-wave = callPackage ./test-export-square-wave { };
    sfxr-qt-starts = nixosTests.sfxr-qt;
  };

  meta = with lib; {
    homepage = "https://github.com/agateau/sfxr-qt";
    description = "Sound effect generator, QtQuick port of sfxr";
    mainProgram = "sfxr-qt";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}
