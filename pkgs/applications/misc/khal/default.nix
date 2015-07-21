{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.6.0";
  name = "khal-${version}";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/k/khal/khal-${version}.tar.gz";
    sha256 = "16nsib70rczln0hrh93bas58lr8crvq8yipj7qnfs4hbs9b8sbhs";
  };

  propagatedBuildInputs = with pythonPackages; [
    atomicwrites
    click
    configobj
    dateutil
    icalendar
    lxml
    pkgs.vdirsyncer
    pytz
    pyxdg
    requests_toolbelt
    tzlocal
    urwid
    python.modules.sqlite3
    pkginfo
  ];

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
