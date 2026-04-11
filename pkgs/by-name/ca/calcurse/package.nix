{
  lib,
  pkg-config,
  stdenv,
  fetchurl,
  ncurses,
  gettext,
  python3,
  python3Packages,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calcurse";
  version = "4.8.2";

  src = fetchurl {
    url = "https://calcurse.org/files/calcurse-${finalAttrs.version}.tar.gz";
    hash = "sha256-hJuoUsfze2dyNlywxCqUzeD+de+6kTY+lqDn73l7pWU=";
  };

  buildInputs = [
    pkg-config
    ncurses
    gettext
    python3
    python3Packages.wrapPython
  ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    patchShebangs .
    buildPythonPath "${python3Packages.httplib2} ${python3Packages.oauth2client}"
    patchPythonScript $out/bin/calcurse-caldav
  '';

  meta = {
    description = "Calendar and scheduling application for the command line";
    longDescription = ''
      calcurse is a calendar and scheduling application for the command line. It helps
      keep track of events, appointments and everyday tasks. A configurable notification
      system reminds users of upcoming deadlines, the curses based interface can be
      customized to suit user needs and a very powerful set of command line options can
      be used to filter and format appointments, making it suitable for use in scripts.
    '';
    homepage = "https://calcurse.org/";
    changelog = "https://git.calcurse.org/calcurse.git/plain/CHANGES.md?h=v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
})
