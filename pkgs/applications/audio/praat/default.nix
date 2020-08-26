{ stdenv, fetchurl, alsaLib, gtk2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "praat";
  version = "6.0.43";

  src = fetchurl {
    url = "https://github.com/praat/praat/archive/v${version}.tar.gz";
    sha256 = "1l13bvnl7sv8v6s5z63201bhzavnj6bnqcj446akippsam13z4sf";
  };

  configurePhase = ''
    cp makefiles/makefile.defs.linux.alsa makefile.defs
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp praat $out/bin
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib gtk2 ];

  meta = {
    description = "Doing phonetics by computer";
    homepage = "http://www.fon.hum.uva.nl/praat/";
    license = stdenv.lib.licenses.gpl2Plus; # Has some 3rd-party code in it though
    platforms = stdenv.lib.platforms.linux;
  };
}
