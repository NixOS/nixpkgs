{
  lib,
  stdenv,
  fetchFromGitHub,
  python27,
  htslib,
  zlib,
  makeWrapper,
}:

let
  python = python27.withPackages (ps: with ps; [ cython ]);

in
stdenv.mkDerivation {
  pname = "platypus-unstable";
  version = "2018-07-22";

  src = fetchFromGitHub {
    owner = "andyrimmer";
    repo = "Platypus";
    rev = "3e72641c69800da0cd4906b090298e654d316ee1";
    sha256 = "0nah6r54b8xm778gqyb8b7rsd76z8ji4g73sm6rvpw5s96iib1vw";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    htslib
    python
    zlib
  ];

  buildPhase = ''
    patchShebangs .
    make
  '';

  installPhase = ''
    mkdir -p $out/libexec/platypus
    cp -r ./* $out/libexec/platypus

    mkdir -p $out/bin
    makeWrapper ${python}/bin/python $out/bin/platypus --add-flags "$out/libexec/platypus/bin/Platypus.py"
  '';

  meta = with lib; {
    description = "Platypus variant caller";
    license = licenses.gpl3;
    homepage = "https://github.com/andyrimmer/Platypus";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
