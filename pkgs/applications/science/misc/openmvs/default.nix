{ lib, stdenv, fetchFromGitHub, pkgconfig, cmake
, eigen, opencv, ceres-solver, cgal, boost, vcg
, gmp, mpfr, glog, google-gflags, libjpeg_turbo }:

stdenv.mkDerivation rec {
  name = "openmvs-unstable-2018-05-26";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "939033c55b50478339084431aac2c2318041afad";
    sha256 = "12dgkwwfdp24581y3i41gsd1k9hq0aw917q0ja5s0if4qbmc8pni";
  };

  buildInputs = [ eigen opencv ceres-solver cgal boost vcg gmp mpfr glog google-gflags libjpeg_turbo ];

  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_CXX_FLAGS=-std=c++11"
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_STATIC_RUNTIME=ON"
      "-DINSTALL_BIN_DIR=$out/bin"
      "-DVCG_DIR=${vcg}"
      "-DCERES_DIR=${ceres-solver}/lib/cmake/Ceres/"
    )
  '';

  cmakeDir = "./";

  dontUseCmakeBuildDir = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for computer-vision scientists and especially targeted to the Multi-View Stereo reconstruction community";
    homepage = http://cdcseacave.github.io/openMVS/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdaiter ];
  };
}
