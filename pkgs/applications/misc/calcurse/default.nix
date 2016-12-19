{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "calcurse-4.0.0";

  src = fetchurl {
    url = http://calcurse.org/files/calcurse-4.0.0.tar.gz;
    sha256 = "0d33cpkbhyidvm3xx6iw9ljqdvl6477c2kcwix3bs63nj0ch06v2";
  };

  buildInputs = [ncurses gettext];

  meta = {
    description = "A calendar and scheduling application for the command line";
    version = "4.0.0";
    longDescription = ''
      calcurse is a calendar and scheduling application for the command line. It helps
      keep track of events, appointments and everyday tasks. A configurable notification
      system reminds users of upcoming deadlines, the curses based interface can be
      customized to suit user needs and a very powerful set of command line options can
      be used to filter and format appointments, making it suitable for use in scripts.
    '';
    homepage = http://calcurse.org/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
