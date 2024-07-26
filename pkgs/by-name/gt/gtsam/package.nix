{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, boost
, eigen
, metis
}:

stdenv.mkDerivation rec {
  pname = "gtsam";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "borglab";
    repo = "gtsam";
    rev = "${version}";
    hash = "sha256-HjpGrHclpm2XsicZty/rX/RM/762wzmj4AAoEfni8es=";
  };

  patches = [
    # Fixes missing include directive in test suite. This causes an error for newer gcc.
    (fetchpatch {
      url = "https://github.com/borglab/gtsam/commit/05f741e08361b55a212adf197cb211275e58ab32.patch";
      hash = "sha256-POjbCjlFAkbLCvnAAmHhcKbCIoOE1NP5TAUhGTpbL5Y=";
     })
  ];

  buildInputs = [
    boost
    eigen
    metis
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF"
    "-DGTSAM_BUILD_TIMING_ALWAYS=OFF"
    "-DGTSAM_BUILD_PYTHON=OFF"           # TODO(fagg): Optional?
    "-DGTSAM_INSTALL_MATLAB_TOOLBOX=OFF"
    "-DGTSAM_USE_QUATERNIONS=OFF"
    "-DGTSAM_USE_POSE3_EXPMAP=ON"
    "-DGTSAM_USE_ROT3_EXPMAP=ON"
    "-DGTSAM_USE_TBB=OFF"                # TODO(fagg): Optional?
    "-DGTSAM_USE_SYSTEM_EIGEN=ON"
    "-DGTSAM_USE_EIGEN_MKL_OPENMP=OFF"
    "-DGTSAM_USE_EIGEN_MKL=OFF"
    "-DEIGEN_USE_MKL_ALL=OFF"
    "-DGTSAM_ALLOCATOR_BOOSTPOOL=OFF"    # TODO(fagg): This should work, but newer gcc complains.
    "-DGTSAM_ALLOCATOR_TBB=OFF"
    "-DGTSAM_ALLOCATOR_STL=ON"
    "-DGTSAM_THROW_CHEIRALITY_EXCEPTION=ON"
    "-DGTSAM_SUPPORT_NESTED_DISSECTION=ON"
    "-DGTSAM_USE_TANGENT_PREINTEGRATION=ON"
    "-DGTSAM_USE_SYSTEM_METIS=ON"
    "-DGTSAM_SLOW_BUT_CORRECT_BETWEENFACTOR=OFF"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for sensor fusion with factor graphs and Bayes networks";
    homepage = "https://gtsam.org";
    licenses = licenses.bsd3;
    maintainers = with maintainers; [ fagg ];
    platforms = platforms.linux;
    changelog = "https://github.com/borglab/gtsam/releases/tag/${src.rev}";
  };
}
