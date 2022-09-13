{ lib, pkgs, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "aacgain";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dgilman";
    repo = "aacgain";
    rev = "9f9ae95a20197d1072994dbd89672bba2904bdb5";
    sha256 = "sha256-WqL9rKY4lQD7wQSZizoM3sHNzLIG0E9xZtjw8y7fgmE=";
    fetchSubmodules = true;
  };

  buildInputs = [
    pkgs.cmake pkgs.autoconf pkgs.automake pkgs.libtool
  ];

  configurePhase = ''
    runHook preConfigure

    mkdir build
    cmake -H. -Bbuild

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cd build; make
    runHook postBuild
  '';

  installPhase = ''
    install -D aacgain/aacgain "$out/bin/aacgain"
  '';

  meta = with lib; {
    description = "ReplayGain for AAC files";
    homepage = "https://github.com/dgilman/aacgain";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.robbinch ];
  };
}
