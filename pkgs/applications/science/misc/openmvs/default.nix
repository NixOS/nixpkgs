{ lib, stdenv, fetchFromGitHub, pkgconfig, cmake
, eigen, opencv, ceres-solver, cgal, boost, vcg
, gmp, mpfr, glog, google-gflags, libjpeg_turbo }:

stdenv.mkDerivation rec {
  name = "openmvs-unstable-2017-05-01";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";

    rev = "a3b360016660a1397f6eb6c070c2c19bbb4c7590";
    sha256 = "170ff4ipix2kqq5rhb1yrrcvc79im9qgp5hiwsdr23xxzdl21221";
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
