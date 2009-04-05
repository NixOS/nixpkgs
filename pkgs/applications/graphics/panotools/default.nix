{stdenv, fetchsvn, libjpeg, libpng, libtiff, automake, libtool, autoconf }:

stdenv.mkDerivation {
  name = "panotools-r955";

  src = fetchsvn {
    url = https://panotools.svn.sourceforge.net/svnroot/panotools/trunk/libpano;
    rev = 955;
  };

  configurePhase = ''
    export AUTOGEN_CONFIGURE_ARGS="--prefix $out"
    ./bootstrap
  '';

  buildInputs = [ libjpeg libpng libtiff automake libtool autoconf ];

  meta = {
    homepage = http://panotools.sourceforge.net/;
    description = "Panorama Tools";
    license = "GPL";
  };
}
