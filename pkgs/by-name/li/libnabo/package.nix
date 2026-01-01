{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
  boost,
}:

stdenv.mkDerivation rec {
  version = "1.1.2";
  pname = "libnabo";

  src = fetchFromGitHub {
    owner = "ethz-asl";
    repo = "libnabo";
    rev = version;
    sha256 = "sha256-/XXRwiLLaEvp+Q+c6lBiuWBb9by6o0pDf8wFtBNp7o8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    eigen
    boost
  ];

  cmakeFlags = [
    "-DEIGEN_INCLUDE_DIR=${eigen}/include/eigen3"
  ];

  doCheck = true;
  checkTarget = "test";

<<<<<<< HEAD
  meta = {
    inherit (src.meta) homepage;
    description = "Fast K Nearest Neighbor library for low-dimensional spaces";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cryptix ];
=======
  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Fast K Nearest Neighbor library for low-dimensional spaces";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cryptix ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
