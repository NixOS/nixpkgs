{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, boost
, qtbase
, qtimageformats
, qttools
, wrapQtAppsHook
}:

let
  boost_static = boost.override { enableStatic = true; };

in stdenv.mkDerivation rec {
  pname = "degate";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "DegateCommunity";
    repo = "Degate";
    rev = "refs/tags/v${version}";
    hash = "sha256-INoA3Z6ya03ZMn6E+nOCkXZLoxoo2WgPDw9v5miI09A=";
  };

  patches = [
    # bump bundled catch2 to avoid incompatibility with modern glibc
    (fetchpatch {
      name = "catch2-2.13.9.patch";
      url = "https://github.com/DegateCommunity/Degate/commit/06346dde4312cbb867854899eacf58679d6ac7e2.patch";
      includes = [ "tests/catch2/catch.hpp" ];
      hash = "sha256-SbSA813QI8RRVy1lvAOGMGAC2KUQKjwYR2imqX40pvU=";
    })
  ];

  postPatch = ''
    sed -i -E '/(_OUTPUT_DIRECTORY|DESTINATION)/s|\bout/||g' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    boost_static
    qtbase
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    (
      cd tests/out/bin

      # provide qtimageformats plugin to allow tests to read tiff files
      export QT_PLUGIN_PATH="${qtimageformats}/${qtbase.qtPluginPrefix}"

      ./DegateTests
    )

    runHook postCheck
  '';

  meta = with lib; {
    description = "Modern and open-source cross-platform software for chips reverse engineering";
    mainProgram = "Degate";
    homepage = "https://degate.readthedocs.io/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ris ];
  };
}
