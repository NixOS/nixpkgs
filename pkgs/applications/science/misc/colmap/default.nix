{ mkDerivation, lib, fetchpatch, fetchFromGitHub, cmake, boost, ceres-solver, eigen,
  freeimage, glog, libGLU, glew, qtbase,
  cudaSupport ? false, cudatoolkit ? null }:

assert !cudaSupport || cudatoolkit != null;

let boost_static = boost.override { enableStatic = true; };
in
mkDerivation rec {
  version = "3.5";
  pname = "colmap";
  src = fetchFromGitHub {
     owner = "colmap";
     repo = "colmap";
     rev = version;
     sha256 = "1vnb62p0y2bnga173wmjs0lnyqdjikv0fkcxjzxm8187khk2lly8";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/colmap/colmap/commit/6af3d8b0048cecc3b9fc6f4e78c3214dd038180b.patch";
      sha256 = "1zv5girmv4hv78w1xn131v8njwhpbyylc1m15731lnhrs8bri0jq";
    })
  ];

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
    homepage = https://colmap.github.io/index.html;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lebastr ];
  };
}
