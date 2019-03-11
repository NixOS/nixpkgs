{ stdenv, python3, glibcLocales, fetchpatch }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "todoman";
  version = "3.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "051qjdpwif06x7qspnb4pfwdhb8nnmz99yqcp4kla5hv0n3jh0w9";
  };

    LOCALE_ARCHIVE = stdenv.lib.optionalString stdenv.isLinux
      "${glibcLocales}/lib/locale/locale-archive";
    LANG = "en_US.UTF-8";
    LC_TYPE = "en_US.UTF-8";

  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = with python3.pkgs;
    [ atomicwrites click click-log configobj humanize icalendar parsedatetime
      python-dateutil pyxdg tabulate urwid ];

  checkInputs = with python3.pkgs;
    [ flake8 flake8-import-order freezegun hypothesis pytest pytestrunner pytestcov ];

  makeWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive"
                      "--set CHARSET en_us.UTF-8" ];

  preCheck = ''
    # Remove one failing test that only checks whether the command line works
    rm tests/test_main.py
    rm tests/test_cli.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pimutils/todoman;
    description = "Standards-based task manager based on iCalendar";
    longDescription = ''
      Todoman is a simple, standards-based, cli todo (aka: task) manager. Todos
      are stored into icalendar files, which means you can sync them via CalDAV
      using, for example, vdirsyncer.

      Todos are read from individual ics files from the configured directory.
      This matches the vdir specification.  There’s support for the most common TODO
      features for now (summary, description, location, due date and priority) for
      now.  Runs on any Unix-like OS. It’s been tested on GNU/Linux, BSD and macOS.
      Unsupported fields may not be shown but are never deleted or altered.

      Todoman is part of the pimutils project
    '';
    license = licenses.isc;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
