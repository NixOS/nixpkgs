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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "cvc5";
    repo = "cvc5";
    tag = "cvc5-${version}";
    hash = "sha256-nxJjrpWZfYPuuKN4CWxOHEuou4r+MdK0AjdEPZHZbHI=";
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
