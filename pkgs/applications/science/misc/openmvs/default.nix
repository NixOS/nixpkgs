{ config
, lib
, boost
, breakpad
, ceres-solver
, cgal
, cmake
, eigen
, fetchFromGitHub
, glfw
, gmp
, libjpeg
, libpng
, libtiff
, mpfr
, opencv
, openmp
, pkg-config
, stdenv
, vcg
}@inputs:

let
  inherit (opencv.cudaPackages)
    backendStdenv
    libcurand
    ;
  stdenv = builtins.throw "Don't use stdenv directly; use effectiveStdenv instead";
  effectiveStdenv = if config.cudaSupport then backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  version = "2.2.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j/tGkR73skZiU+bP4j6aZ5CxkbIcHtqKcaUTgNvj0C8=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    # SSE is enabled by default
    (lib.cmakeBool "OpenMVS_USE_SSE" effectiveStdenv.isx86_64)
    (lib.cmakeBool "OpenMVS_USE_CUDA" config.cudaSupport)
  ] ++ lib.optionals config.cudaSupport [
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "-E;PipelineTest")
  ];

  buildInputs = [
    boost
    breakpad
    ceres-solver
    cgal
    eigen
    glfw
    gmp
    libjpeg
    libpng
    libtiff
    mpfr
    (lib.getOutput "cxxdev" opencv)
    openmp
    vcg
  ] ++ lib.optionals config.cudaSupport [ libcurand ];

  nativeBuildInputs = [ cmake pkg-config ];

  postInstall = ''
    mv $out/bin/OpenMVS/* $out/bin
    rmdir $out/bin/OpenMVS
    rm $out/bin/Tests
  '';

  doCheck = true;

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bouk ];
  };
})
