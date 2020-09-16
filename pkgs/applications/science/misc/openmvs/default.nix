{ stdenv, fetchFromGitHub, pkgconfig, cmake
, eigen, opencv, ceres-solver, cgal_5, boost, vcg
, gmp, mpfr, glog, gflags, libjpeg_turbo }:

stdenv.mkDerivation {
  name = "openmvs";
  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    rev = "v1.1.1";
    sha256 = "15xx1z9hp7cj2m6czqcr75fhgjj0cvzq25g9kzx4c3dm44vz2l67";
  };

  buildInputs = [ eigen opencv ceres-solver cgal_5 boost vcg gmp mpfr glog gflags libjpeg_turbo ];

  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_CXX_FLAGS=-std=c++11"
      "-DBUILD_SHARED_LIBS=OFF"
      "-DBUILD_STATIC_RUNTIME=ON"
      "-DINSTALL_BIN_DIR=$out/bin"
      "-DVCG_DIR=${vcg}"
      "-DCGAL_ROOT=${cgal_5}/lib/cmake/CGAL"
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for computer-vision scientists and especially targeted to the Multi-View Stereo reconstruction community";
    homepage = "http://cdcseacave.github.io/openMVS/";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mdaiter timput ];
  };
}
