{ stdenv, pkgs, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "khal";
  version = "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1blx3gxnv7sj302biqphfw7i6ilzl2xlmvzp130n3113scg9w17y";
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
