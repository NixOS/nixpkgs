{ stdenv, lib, fetchFromGitHub, cmake, boost, ceres-solver, eigen,
  freeimage, glog, libGLU, glew, qt5,
  cudaSupport ? false, cudatoolkit ? null }:

assert !cudaSupport || cudatoolkit != null;

let boost_static = boost.override {enableStatic = true; };
in 
stdenv.mkDerivation rec {
  version = "3.5";
  name = "colmap-" + version;
  src = fetchFromGitHub {
     owner = "colmap";
     repo = "colmap";
     rev = version;
     sha256 = "1vnb62p0y2bnga173wmjs0lnyqdjikv0fkcxjzxm8187khk2lly8";
  };
  
  buildInputs = [ boost_static ceres-solver eigen freeimage
                  glog libGLU glew
		  qt5.qtbase ] ++
		  lib.optionals cudaSupport [ cudatoolkit ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline with a graphical and command-line interface.";
    homepage = https://colmap.github.io/index.html;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lebastr ];
  };
}
