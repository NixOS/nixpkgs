{ stdenv, fetchurl, pkgs, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.8.2";
  name = "khal-${version}";

  src = fetchurl {
    url = "mirror://pypi/k/khal/khal-${version}.tar.gz";
    sha256 = "0ihclh3jsxhvq7azgdxbdzwbl7my30cdcg3g5ss5bpm4ivskrzzj";
  };

  propagatedBuildInputs = with python3Packages; [
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
    pkginfo
    freezegun
  ];
  buildInputs = with python3Packages; [ setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
