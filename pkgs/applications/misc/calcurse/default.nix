{stdenv, fetchurl, ncurses, gettext, python3, makeWrapper }:

stdenv.mkDerivation rec {
  name = "calcurse-${version}";
  version = "4.2.2";

  src = fetchurl {
    url = "http://calcurse.org/files/${name}.tar.gz";
    sha256 = "0il0y06akdqgy0f9p40m4x6arn66nh7sr1w1i41bszycs7div266";
  };

  buildInputs = [ncurses gettext python3 ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${python3}/bin/python3 $out/bin/calcurse-caldav 
      '';

  meta = with stdenv.lib; {
    description = "A calendar and scheduling application for the command line";
    longDescription = ''
      calcurse is a calendar and scheduling application for the command line. It helps
      keep track of events, appointments and everyday tasks. A configurable notification
      system reminds users of upcoming deadlines, the curses based interface can be
      customized to suit user needs and a very powerful set of command line options can
      be used to filter and format appointments, making it suitable for use in scripts.
    '';
    homepage = http://calcurse.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
