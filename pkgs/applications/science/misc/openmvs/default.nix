{
  lib,
  boost,
  ceres-solver,
  cgal,
  cmake,
  eigen,
  fetchFromGitHub,
  glfw,
  gmp,
  libjpeg,
  libpng,
  libtiff,
  mpfr,
  opencv,
  openmp,
  pkg-config,
  stdenv,
  vcg,
  zstd,
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
    hash = "sha256-j/tGkR73skZiU+bP4j6aZ5CxkbIcHtqKcaUTgNvj0C8=";
    fetchSubmodules = true;
  };

  # SSE is enabled by default
  cmakeFlags = lib.optional (!stdenv.hostPlatform.isx86_64) "-DOpenMVS_USE_SSE=OFF";

  buildInputs = [
    boostWithZstd
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
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

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
}
