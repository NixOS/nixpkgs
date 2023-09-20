{ lib
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
, zstd
, config
, cudaSupport ? config.cudaSupport
, cudatoolkit
, addOpenGLRunpath
}:

let
  boostWithZstd = boost.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ zstd ];
  });
in
stdenv.mkDerivation rec {
  version = "2.2.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "v${version}";
    sha256 = "sha256-j/tGkR73skZiU+bP4j6aZ5CxkbIcHtqKcaUTgNvj0C8=";
    fetchSubmodules = true;
  };

  # SSE is enabled by default
  cmakeFlags = lib.optionals (!stdenv.isx86_64) [
    "-DOpenMVS_USE_SSE=OFF"
  ] ++ lib.optionals cudaSupport [
    "-DCMAKE_LIBRARY_PATH=${cudatoolkit}/lib/stubs"
  ];

  buildInputs = [
    boostWithZstd
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
    opencv
    openmp
    vcg
  ] ++ lib.optionals cudaSupport [
    cudatoolkit
  ];

  nativeBuildInputs = [ cmake pkg-config ] ++ lib.optionals cudaSupport [
    addOpenGLRunpath
  ];

  postInstall = ''
    mv $out/bin/OpenMVS/* $out/bin
    rmdir $out/bin/OpenMVS
    rm $out/bin/Tests
  '';

  postFixup = lib.optionalString cudaSupport ''
    addOpenGLRunpath $out/bin/*
  '';

  # We can't run the tests because they require the opengl run path to be available
  doCheck = !cudaSupport;
  checkPhase = ''
    runHook preCheck
    ctest
    runHook postCheck
  '';

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bouk ];
  };
}
