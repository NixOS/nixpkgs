{ fetchurl, stdenv, texLive, python, makeWrapper, pkgconfig
, libX11, qt4, enchant #, mythes, boost
}:

stdenv.mkDerivation rec {
  version = "2.0.4";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.0.x/${name}.tar.xz";
    sha256 = "137dzmz1z6aqz9mdj8gmmi0k60s9sfn6gy916j175cwzq6hpncb8";
  };

  configureFlags = [
    #"--without-included-boost"
    /*  Boost is a huge dependency from which 1.4 MB of libs would be used.
        Using internal boost stuff only increases executable by around 0.2 MB. */
    #"--without-included-mythes" # such a small library isn't worth a split package
  ];

  buildInputs = [
    texLive qt4 python makeWrapper pkgconfig
    enchant # mythes boost
  ];

  meta = {
    description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
    homepage = "http://www.lyx.org";
    license = "GPL2";
    maintainers = [ stdenv.lib.maintainers.neznalek ];
    platforms = stdenv.lib.platforms.linux;
  };
}
