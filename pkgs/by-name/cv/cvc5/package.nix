{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  flex,
  cadical,
  symfpu,
  gmp,
  python3,
  gtest,
  boost,
  jdk,
  libpoly,
}:

stdenv.mkDerivation rec {
  pname = "cvc5";
<<<<<<< HEAD
  version = "1.3.2";
=======
  version = "1.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cvc5";
    repo = "cvc5";
    tag = "cvc5-${version}";
<<<<<<< HEAD
    hash = "sha256-Um1x+XgQ5yWSoqtx1ZWbVAnNET2C4GVasIbn0eNfico=";
=======
    hash = "sha256-nxJjrpWZfYPuuKN4CWxOHEuou4r+MdK0AjdEPZHZbHI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    flex
  ];
  buildInputs = [
    cadical.dev
    symfpu
    gmp
    gtest
    boost
    jdk
    libpoly
    (python3.withPackages (
      ps: with ps; [
        pyparsing
        tomli
      ]
    ))
  ];

  preConfigure = ''
    patchShebangs ./src/
  '';

  cmakeBuildType = "Production";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
    "-DUSE_POLY=ON"
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "cvc5";
    homepage = "https://cvc5.github.io";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shadaj ];
=======
  meta = with lib; {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "cvc5";
    homepage = "https://cvc5.github.io";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ shadaj ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
