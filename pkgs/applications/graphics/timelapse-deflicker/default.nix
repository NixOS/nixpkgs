{ stdenv, fetchgit, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "timelapse-deflicker-${version}";
  version = "142acd1";

  src = fetchgit {
    url = "https://github.com/cyberang3l/timelapse-deflicker.git";
    rev = "142acd1";
    sha256 = "0bbfnrdycrpyz7rqrql5ib9qszny7z5xpqp65c1mxqd2876gv960";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv timelapse-deflicker.pl $out/bin/timelapse-deflicker

    wrapProgram $out/bin/timelapse-deflicker --prefix PERL5LIB : \
      "${with perlPackages; stdenv.lib.makePerlPath [
        PerlMagick
        TermProgressBar
        ImageExifTool
        FileType
        ClassMethodMaker
      ]}"
  '';

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  buildInputs = [ makeWrapper perl ];

  meta = with stdenv.lib; {
    description = "Simple script to deflicker images taken for timelapses";
    homepage = https://github.com/cyberang3l/timelapse-deflicker;
    license = stdenv.lib.licenses.gpl3;
    platforms = platforms.unix;
  };
}
