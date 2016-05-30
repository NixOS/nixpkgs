{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "calcurse-4.1.0";

  src = fetchurl {
    url = http://calcurse.org/files/calcurse-4.1.0.tar.gz;
    sha256 = "1i22kdhzgzw4flqqd7pfzjpac2997ji5yc416bb2rfgvin63yhna";
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
