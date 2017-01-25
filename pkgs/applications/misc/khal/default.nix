{ stdenv, fetchurl, pkgs, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  # Reenable tests for 0.9.0, they are broken at the moment: #15981
  version = "0.8.4";
  name = "khal-${version}";

  src = fetchurl {
    url = "mirror://pypi/k/khal/khal-${version}.tar.gz";
    sha256 = "03vy4dp9n43w51mwqjjy08dr5nj7wxqnb085visz3j43vzm42p1f";
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
