{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "arguments";
  version = "1.4.60-unstable-2023-01-18";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "arguments";
    rev = "ed7c4c126b800d4312469e3cd3999a31e96fed0e";
    hash = "sha256-1QxVZ17zSqx5P9nGAXHf7Fj86fuGn17PllGXFqyYJUo=";
=======
stdenv.mkDerivation rec {
  pname = "arguments";
  version = "unstable-2015-11-30";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo = "arguments";
    rev = "b3aad97f6b6892cb8733455d0d448649a48fa108";
    sha256 = "1ar8lm1w1jflz3vdmjr5c4x6y7rscvrj78b8gmrv79y95qrgzv6s";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
  doCheck = false; # test binary not built by cmake

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/arguments";
    description = "Library for argument handling for MINC programs";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
=======
  #cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib" "-DBICPL_DIR=${bicpl}/lib" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    homepage = "https://github.com/${owner}/arguments";
    description = "Library for argument handling for MINC programs";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
