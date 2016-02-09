{ stdenv, fetchsvn, automake, autoconf, zlib, popt, xorg, libvorbis, libtheora }:

stdenv.mkDerivation rec {
  name = "recordmydesktop-${version}";
  version = "0.3.8.1-svn602";

  src = fetchsvn {
    url = https://recordmydesktop.svn.sourceforge.net/svnroot/recordmydesktop/trunk/recordmydesktop;
    rev = 602;
    sha256 = "1avirkc4ymrd575m616pi6wpgq1i0r5sb3qahps1g18sjpxks0lf";
  };

  buildInputs = [ automake autoconf zlib popt xorg.libICE xorg.libSM xorg.libX11 xorg.libXext xorg.libXfixes xorg.libXdamage libvorbis libtheora ];

  preConfigure = ''./autogen.sh'';

  meta = with stdenv.lib; {
    description = "Desktop session recorder";
    homepage = http://recordmydesktop.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.DamienCassou ];
  };
}
