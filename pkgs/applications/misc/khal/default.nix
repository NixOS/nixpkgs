{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.5.0";
  name = "khal-${version}";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/k/khal/khal-${version}.tar.gz";
    sha256 = "1042vnc0vsaf0yr44hb0bh227d4rn81smvxksrzwdwja3wwxk4m9";
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
