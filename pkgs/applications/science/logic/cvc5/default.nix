{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, flex, cadical, symfpu, gmp, python3, gtest, libantlr3c, antlr3_4, boost, jdk }:

stdenv.mkDerivation rec {
  pname = "cvc5";
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "1.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "cvc5";
    repo   = "cvc5";
    rev    = "cvc5-${version}";
<<<<<<< HEAD
    hash  = "sha256-0uT2Lzz0ZbfNWZBptjaGI1fN0mMniBz41eEwipGc5fc=";
=======
    hash  = "sha256-l+L59QLLrAEVkAZjhxICJpa+j+jr1k/7B61JlapXGRI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config cmake flex ];
  buildInputs = [
    cadical.dev symfpu gmp gtest libantlr3c antlr3_4 boost jdk
<<<<<<< HEAD
    (python3.withPackages (ps: with ps; [ pyparsing tomli ]))
=======
    (python3.withPackages (ps: with ps; [ pyparsing toml ]))
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

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
