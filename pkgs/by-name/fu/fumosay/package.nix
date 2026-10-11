{
  stdenv,
  libunistring,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fumosay";
  version = "1.2.2";

  buildInputs = [
    libunistring
  ];

  src = fetchFromGitHub {
    owner = "randomtwdude";
    repo = "fumosay";
    rev = "baa28c814f45b6b36f7896729e4388ac56fb1136";
    sha256 = "sha256-W6cOjYSw7EL5FCfsbmVBMPLGoXXx+7MoWJQEjtmvy/A=";
  };

  buildPhase = "$CC -o fumosay fumosay.c fumoutil.c fumolang.c -lm -lunistring";
  installPhase = ''
    mkdir -p $out/bin
    mv ./fumosay $out/bin
  '';
}
