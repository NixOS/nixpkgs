{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  flex,
  cadical,
  cadical' ? cadical.override { version = "2.1.3"; },
  symfpu,
  gmp,
  python3,
  gtest,
  boost,
  jdk,
  libpoly,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cvc5";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "cvc5";
    repo = "cvc5";
    tag = "cvc5-${finalAttrs.version}";
    hash = "sha256-Um1x+XgQ5yWSoqtx1ZWbVAnNET2C4GVasIbn0eNfico=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    flex
    (python3.withPackages (
      ps: with ps; [
        pyparsing
        tomli
      ]
    ))
  ];
  buildInputs = [
    cadical'.dev
    symfpu
    gmp
    gtest
    boost
    jdk
    libpoly
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

  meta = {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "cvc5";
    homepage = "https://cvc5.github.io";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shadaj ];
  };
})
