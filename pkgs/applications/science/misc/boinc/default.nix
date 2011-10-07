{ fetchsvn, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK,
sqlite, gtk, patchelf, libXScrnSaver, libnotify, libX11 }:

stdenv.mkDerivation rec {
  name = "boinc-6.13.6";

  src = fetchsvn {
    url = "http://boinc.berkeley.edu/svn/tags/boinc_core_release_6_13_6";
    rev = 24341;
    sha256 = "17312g4mhxigka1rafxxw46a4mbdlfj1wh1nlp1cbg43hv2rf7bq";
  };

  buildInputs = [ libtool automake autoconf m4 pkgconfig curl mesa libXmu libXi
    freeglut libjpeg wxGTK sqlite gtk libXScrnSaver libnotify patchelf libX11 ];

  postConfigure = ''
    sed -i -e s,/etc,$out/etc, client/scripts/Makefile
  '';

  preConfigure = ''
    ./_autosetup
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  enableParallelBuilding = true;

  configureFlags = "--disable-server --disable-fast-install";

  postInstall = "
    # Remove a leading rpath to /tmp/... I don't know how it got there
    # I could not manage to get rid of that through autotools.
    for a in $out/bin/*; do
      RPATH=$(patchelf --print-rpath $a)
      NEWRPATH=$(echo $RPATH | sed 's/^[^:]*://')
      patchelf --set-rpath $out/lib:$NEWRPATH $a
    done
  ";

  meta = {
    description = "Free software for distributed and grid computing";

    homepage = http://boinc.berkeley.edu/;

    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
