{ lib, stdenv, fetchurl, makeWrapper, bash, bc, findutils, flac, lame, opusTools, procps, sox }:

let
  version = "1.7.5";
in

stdenv.mkDerivation {
  pname = "caudec";
  inherit version;

  src = fetchurl {
    url = "http://caudec.net/downloads/caudec-${version}.tar.gz";
    sha256 = "5d1f5ab3286bb748bd29cbf45df2ad2faf5ed86070f90deccf71c60be832f3d5";
  };

  preBuild = ''
    patchShebangs ./install.sh
  '';

  nativeBuildInputs = [ bash makeWrapper ];

  installPhase = ''
    ./install.sh --prefix=$out/bin
  '';

  postFixup = ''
    for executable in $(cd $out/bin && ls); do
  wrapProgram $out/bin/$executable \
    --prefix PATH : "${lib.makeBinPath [ bc findutils sox procps opusTools lame flac ]}"
    done
  '';

   meta = with lib; {
    homepage = "http://caudec.net/";
    description = "A multiprocess audio converter that supports many formats (FLAC, MP3, Ogg Vorbis, Windows codecs and many more)";
    license     = licenses.gpl3;
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
