{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, cadical, symfpu, gmp, git, python3, gtest, libantlr3c, antlr3_4, boost, jdk }:

stdenv.mkDerivation rec {
  pname = "cvc5";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner  = "cvc5";
    repo   = "cvc5";
    rev    = "cvc5-${version}";
    sha256 = "sha256-CVXK6yehfUrSbo8R1Dk1oc/siCtmV9DjEp6q+aLuVQA=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ cadical.dev symfpu gmp git python3 python3.pkgs.toml gtest libantlr3c antlr3_4 boost jdk ];

  preConfigure = ''
    patchShebangs ./src/
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Production"
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
