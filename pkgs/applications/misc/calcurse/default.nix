{ stdenv, fetchurl, ncurses, gettext, python3, python3Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "calcurse";
  version = "4.6.0";

  src = fetchurl {
    url = "https://calcurse.org/files/${pname}-${version}.tar.gz";
    sha256 = "0hzhdpkkn75jlymanwzl69hrrf1pw29hrchr11wlxqjpl43h62gs";
  };

  buildInputs = [ ncurses gettext python3 python3Packages.wrapPython ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    patchShebangs .
    buildPythonPath ${python3Packages.httplib2}
    patchPythonScript $out/bin/calcurse-caldav
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
    homepage = "https://calcurse.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
