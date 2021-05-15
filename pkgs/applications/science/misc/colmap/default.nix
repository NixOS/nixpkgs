{ mkDerivation, lib, fetchFromGitHub, cmake, boost17x, ceres-solver, eigen,
  freeimage, glog, libGLU, glew, qtbase,
  cudaSupport ? false, cudatoolkit ? null }:

assert !cudaSupport || cudatoolkit != null;

let boost_static = boost17x.override { enableStatic = true; };
in
mkDerivation rec {
  version = "3.6";
  pname = "colmap";
  src = fetchFromGitHub {
     owner = "colmap";
     repo = "colmap";
     rev = version;
     sha256 = "1kfivdmhpmdxjjf30rr57y2iy7xmdpg4h8aw3qgacv8ckfpgda3n";
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
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lebastr ];
  };
}
