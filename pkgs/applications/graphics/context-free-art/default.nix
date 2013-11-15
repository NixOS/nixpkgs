{ fetchurl, stdenv, flex, bison, libpng, ffmpeg }: 

stdenv.mkDerivation rec {
  version = "3.0.5";
  name = "context-free-${version}";

  src = fetchurl {
    url = "http://www.contextfreeart.org/download/ContextFreeSource3.0.5.tgz";
    sha256 = "00pilz369wp47bzxsr46mpq6bib82swgvxjjb1va77qnlk6j2vrp";
  };
  
  buildInputs = [flex bison libpng ffmpeg ];

  installPhase = ''
    mkdir -p $out/bin
    cp cfdg $out/bin/
  '';

  patches = [ ./fix.patch ];

  meta = {
    license = stdenv.lib.licenses.gpl2;
    description = "Context Free is a program that generates images from written instructions";
    homepage = http://contextfreeart.org/index.html;
  };
}
