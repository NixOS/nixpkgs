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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cvc5";
    repo = "cvc5";
    rev = "cvc5-${version}";
    hash = "sha256-w8rIGPG9BTEPV9HG2U40A4DYYnC6HaWbzqDKCRhaT00=";
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

  meta = with lib; {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "cvc5";
    homepage = "https://cvc5.github.io";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ shadaj ];
  };
}
