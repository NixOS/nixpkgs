{ fetchsvn, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool }:

stdenv.mkDerivation rec {
  name = "boinc-6.13.6";

  src = fetchsvn {
    url = "http://boinc.berkeley.edu/svn/tags/boinc_core_release_6_13_6";
    rev = 24341;
    sha256 = "17312g4mhxigka1rafxxw46a4mbdlfj1wh1nlp1cbg43hv2rf7bq";
  };

  buildInputs = [ libtool automake autoconf m4 pkgconfig curl mesa libXmu libXi
    freeglut libjpeg ];

  postConfigure = ''
    sed -i -e s,/etc,$out/etc, client/scripts/Makefile
  '';

  preConfigure = ''
    ./_autosetup
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  configureFlags = "--disable-server";

  meta = {
    description = "Free software for distributed and grid computing";

    homepage = http://boinc.berkeley.edu/;

    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
