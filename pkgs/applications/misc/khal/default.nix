{ stdenv, fetchurl, pkgs, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  version = "0.9.2";
  name = "khal-${version}";

  src = fetchurl {
    url = "mirror://pypi/k/khal/khal-${version}.tar.gz";
    sha256 = "1ryh5c7408w8gpql5s9mkxkvz1ngnds3xm43p7r96ynx8prr9swp";
  };

  LC_ALL = "en_US.UTF-8";

  propagatedBuildInputs = [
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
  buildInputs = [ setuptools_scm pytest pkgs.glibcLocales ];

  checkPhase = ''
    # py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
  };
}
