{ stdenv, fetchsvn, autoreconfHook, zlib, popt, alsaLib, libvorbis, libtheora
, libICE, libSM, libX11, libXext, libXfixes, libXdamage }:

stdenv.mkDerivation rec {
  name = "recordmydesktop-${version}";
  version = "0.3.8.1-svn${rev}";
  rev = "602";

  src = fetchsvn {
    url = https://recordmydesktop.svn.sourceforge.net/svnroot/recordmydesktop/trunk/recordmydesktop;
    inherit rev;
    sha256 = "1avirkc4ymrd575m616pi6wpgq1i0r5sb3qahps1g18sjpxks0lf";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    zlib popt alsaLib libICE libSM libX11 libXext
    libXfixes libXdamage libvorbis libtheora
  ];

  meta = with stdenv.lib; {
    description = "Desktop session recorder";
    homepage = http://recordmydesktop.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.DamienCassou ];
  };
}
