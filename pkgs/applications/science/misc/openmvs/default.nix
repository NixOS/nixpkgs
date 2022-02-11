{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, eigen
, opencv
, ceres-solver
, cgal
, boost
, vcg
, gmp
, mpfr
, glog
, gflags
, libjpeg_turbo
}:

stdenv.mkDerivation {
  pname = "openmvs";
  version = "unstable-2018-05-26";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "939033c55b50478339084431aac2c2318041afad";
    sha256 = "12dgkwwfdp24581y3i41gsd1k9hq0aw917q0ja5s0if4qbmc8pni";
  };

  buildInputs = [ eigen opencv ceres-solver cgal boost vcg gmp mpfr glog gflags libjpeg_turbo ];

  nativeBuildInputs = [ cmake pkg-config ];

  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_CXX_FLAGS=-std=c++11"
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_STATIC_RUNTIME=ON"
      "-DINSTALL_BIN_DIR=$out/bin"
      "-DVCG_DIR=${vcg}"
      "-DCGAL_ROOT=${cgal}/lib/cmake/CGAL"
      "-DCERES_DIR=${ceres-solver}/lib/cmake/Ceres/"
    )
  '';

  postFixup = ''
    rp=$(patchelf --print-rpath $out/bin/DensifyPointCloud)
    patchelf --set-rpath $rp:$out/lib/OpenMVS $out/bin/DensifyPointCloud

    rp=$(patchelf --print-rpath $out/bin/InterfaceVisualSFM)
    patchelf --set-rpath $rp:$out/lib/OpenMVS $out/bin/InterfaceVisualSFM

    rp=$(patchelf --print-rpath $out/bin/ReconstructMesh)
    patchelf --set-rpath $rp:$out/lib/OpenMVS $out/bin/ReconstructMesh

    rp=$(patchelf --print-rpath $out/bin/RefineMesh)
    patchelf --set-rpath $rp:$out/lib/OpenMVS $out/bin/RefineMesh

    rp=$(patchelf --print-rpath $out/bin/TextureMesh)
    patchelf --set-rpath $rp:$out/lib/OpenMVS $out/bin/TextureMesh
  '';

  cmakeDir = "./";

  dontUseCmakeBuildDir = true;

  meta = with lib; {
    description = "A library for computer-vision scientists and especially targeted to the Multi-View Stereo reconstruction community";
    homepage = "http://cdcseacave.github.io/openMVS/";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdaiter ];
    # 20190414-174115: CMake cannot find CGAL which is passed as build input
    broken = true;
  };
}
