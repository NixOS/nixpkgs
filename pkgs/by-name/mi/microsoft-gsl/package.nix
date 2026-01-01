{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "microsoft-gsl";
<<<<<<< HEAD
  version = "4.2.1";
=======
  version = "4.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rfSfgyjU1U6gaWzlx2CeaCSb784L29vHDAC/PQl+s6E=";
=======
    hash = "sha256-NrnYfCCeQ50oHYFbn9vh5Z4mfyxc0kAM3qnzQdq9gyM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ gtest ];

  # C++17 required by latest gtest
  env.NIX_CFLAGS_COMPILE = "-std=c++17";

  doCheck = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "C++ Core Guideline support library";
    longDescription = ''
      The Guideline Support Library (GSL) contains functions and types that are suggested for
      use by the C++ Core Guidelines maintained by the Standard C++ Foundation.
      This package contains Microsoft's implementation of GSL.
    '';
    homepage = "https://github.com/Microsoft/GSL";
<<<<<<< HEAD
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
=======
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      thoughtpolice
      yuriaisaka
    ];
  };
}
