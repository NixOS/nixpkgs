{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, flex, cadical, symfpu, gmp, python3, gtest, libantlr3c, antlr3_4, boost, jdk }:

stdenv.mkDerivation rec {
  pname = "cvc5";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner  = "cvc5";
    repo   = "cvc5";
    rev    = "cvc5-${version}";
    hash  = "sha256-AwUQHFftn51Xt6HtmDsWAdkOS8i64r2FhaHu31KYwZA=";
  };

  nativeBuildInputs = [ pkg-config cmake flex ];
  buildInputs = [
    cadical.dev symfpu gmp gtest libantlr3c antlr3_4 boost jdk
    (python3.withPackages (ps: with ps; [ pyparsing tomli ]))
  ];

  preConfigure = ''
    patchShebangs ./src/
  '';

  cmakeBuildType = "Production";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
    "-DANTLR3_JAR=${antlr3_4}/lib/antlr/antlr-3.4-complete.jar"
  ];

  meta = with lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "https://cvc5.github.io";
    license     = licenses.gpl3Only;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ shadaj ];
  };
}
