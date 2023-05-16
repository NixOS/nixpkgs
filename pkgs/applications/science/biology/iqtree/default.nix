{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, eigen
, zlib
<<<<<<< HEAD
, llvmPackages
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "iqtree";
<<<<<<< HEAD
  version = "2.2.2.7";
=======
  version = "2.2.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "iqtree";
    repo = "iqtree2";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XyjVo5TYMoB+ZOAGc4ivYqFGnEO1M7mhxXrG45TP44Y=";
=======
    sha256 = "sha256:0ickw1ldpvv2m66yzbvqfhn8k07qdkhbjrlqjs6vcf3s42j5c6pq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
  buildInputs = [
    boost
    eigen
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    llvmPackages.openmp
  ];
=======
  buildInputs = [ boost eigen zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "http://www.iqtree.org/";
    description = "Efficient and versatile phylogenomic software by maximum likelihood";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bzizou ];
<<<<<<< HEAD
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
