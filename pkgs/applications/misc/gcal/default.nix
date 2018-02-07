{ stdenv, fetchurl, pkgconfig, ncurses  }:

stdenv.mkDerivation rec {
  name = "gcal-${version}";
  version = "4.1";

  src = fetchurl {
    url = "mirror://gnu/gcal/${name}.tar.xz";
    sha256 = "1av11zkfirbixn05hyq4xvilin0ncddfjqzc4zd9pviyp506rdci";
  };

  enableParallelBuilding = true;

  buildInputs = [ ncurses ];

  meta = {
    description = "Program for calculating and printing calendars";
    longDescription = ''
      Gcal is the GNU version of the trusty old cal(1). Gcal is a
      program for calculating and printing calendars. Gcal displays
      hybrid and proleptic Julian and Gregorian calendar sheets.  It
      also displays holiday lists for many countries around the globe.
    '';
    homepage = https://www.gnu.org/software/gcal/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
