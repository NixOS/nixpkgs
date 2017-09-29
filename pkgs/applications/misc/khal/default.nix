{ stdenv, pkgs, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "khal";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x1p62ff7ggb172rjr6sbdrjh1gl3ck3bwxsqlsix8i5wycwvnmv";
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
