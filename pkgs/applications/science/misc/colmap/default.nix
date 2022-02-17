{ mkDerivation, lib, fetchFromGitHub, cmake, boost17x, ceres-solver, eigen,
  freeimage, glog, libGLU, glew, qtbase,
  cudaSupport ? false, cudatoolkit ? null }:

assert !cudaSupport || cudatoolkit != null;

let boost_static = boost17x.override { enableStatic = true; };
in
mkDerivation rec {
  version = "3.7";
  pname = "colmap";
  src = fetchFromGitHub {
     owner = "colmap";
     repo = "colmap";
     rev = version;
     sha256 = "sha256-uVAw6qwhpgIpHkXgxttKupU9zU+vD0Za0maw2Iv4x+I=";
  };

  buildInputs = [
    boost_static ceres-solver eigen
    freeimage glog libGLU glew qtbase
  ] ++ lib.optional cudaSupport cudatoolkit;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "COLMAP - Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
       COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
       with a graphical and command-line interface.
    '';
    homepage = "https://colmap.github.io/index.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lebastr ];
  };
}
