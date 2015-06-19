{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.5.0";
  name = "khal-${version}";

  src = fetchurl {
    url = "https://github.com/geier/khal/archive/v${version}.tar.gz";
    sha256 = "1rjs5s8ky4n628rs6l5ggaj2abb4kq2avvxmimjjgxz3zh9xlz6s";
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
  ];

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
