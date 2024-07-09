{ lib, stdenv, fetchFromGitHub, pkg-config, cmake
, cereal
, ceres-solver
, clp
, coin-utils
, eigen
, lemon-graph
, libjpeg
, libpng
, libtiff
, nix-update-script
, openmp
, osi
, zlib
, enableShared ? !stdenv.hostPlatform.isStatic
, enableExamples ? false
, enableDocs ? false }:

stdenv.mkDerivation rec {
  version = "2.1";
  pname = "openmvg";

  src = fetchFromGitHub {
    owner = "openmvg";
    repo = "openmvg";
    rev = "v${version}";
    hash = "sha256-vG+tW9Gl/DAUL8DeY+rJVDJH/oMPH3XyZMUgzjtwFv0=";
  };

  # Pretend we checked out the dependency submodules
  postPatch = ''
    mkdir src/dependencies/cereal/include
  '';

  buildInputs = [
    cereal
    ceres-solver
    clp
    coin-utils
    eigen
    lemon-graph
    libjpeg
    libpng
    libtiff
    openmp
    osi
    zlib
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  # flann is missing because the lz4 dependency isn't propagated: https://github.com/openMVG/openMVG/issues/1265
  cmakeFlags = [
    "-DOpenMVG_BUILD_EXAMPLES=${if enableExamples then "ON" else "OFF"}"
    "-DOpenMVG_BUILD_DOC=${if enableDocs then "ON" else "OFF"}"
    "-DTARGET_ARCHITECTURE=generic"
    "-DCLP_INCLUDE_DIR_HINTS=${lib.getDev clp}/include"
    "-DCOINUTILS_INCLUDE_DIR_HINTS=${lib.getDev coin-utils}/include"
    "-DLEMON_INCLUDE_DIR_HINTS=${lib.getDev lemon-graph}/include"
    "-DOSI_INCLUDE_DIR_HINTS=${lib.getDev osi}/include"
  ] ++ lib.optional enableShared "-DOpenMVG_BUILD_SHARED=ON";

  cmakeDir = "./src";

  dontUseCmakeBuildDir = true;

  # This can be enabled, but it will exhause virtual memory on most machines.
  enableParallelBuilding = false;

  # Without hardeningDisable, certain flags are passed to the compile that break the build (primarily string format errors)
  hardeningDisable = [ "all" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = stdenv.isDarwin && stdenv.isx86_64;
    description = "Library for computer-vision scientists and targeted for the Multiple View Geometry community";
    homepage = "https://openmvg.readthedocs.io/en/latest/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mdaiter bouk ];
  };
}
