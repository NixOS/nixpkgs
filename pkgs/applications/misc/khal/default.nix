{ stdenv, pkgs, python3 }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p49f3g25x900vk32spjbr2aipj12kcbhayny2vwhdpkjlv6k396";
  };

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
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
  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest ];

  postInstall = ''
    install -D misc/__khal $out/share/zsh/site-functions/__khal
  '';

  doCheck = true;

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
