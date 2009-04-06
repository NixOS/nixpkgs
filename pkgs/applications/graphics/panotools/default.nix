{stdenv, fetchsvn, libjpeg, libpng, libtiff, automake, libtool, autoconf }:

stdenv.mkDerivation {
  name = "panotools-r955";

  src = fetchsvn {
    url = https://panotools.svn.sourceforge.net/svnroot/panotools/trunk/libpano;
    rev = 955;
    sha256 = "e896c21caa098d33f33f33f134a8c9a725686c2470fe3cd08b76cd7934a56034";
  };

  configurePhase = ''
    export AUTOGEN_CONFIGURE_ARGS="--prefix $out"
    ./bootstrap
  '';

  buildInputs = [ libjpeg libpng libtiff automake libtool autoconf ];

  meta = {
    homepage = http://panotools.sourceforge.net/;
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    license = "LGPL";
  };
}
