{ lib
, fetchFromGitHub
, python
, transmission
, deluge
, config
}:

with python.pkgs;

buildPythonApplication rec {
  version = "2.10.83";
  name = "FlexGet-${version}";

  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = version;
    sha256 = "08r99259zg4czkyzlkg87bn9v7lfkgc71kf1v41cps7k2pq817wh";
  };

  doCheck = true;
  # test_regexp requires that HOME exist, test_filesystem requires a
  # unicode-capable filesystem (and setting LC_ALL doesn't work).
  # setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  postPatch = ''
    sed -i '/def test_non_ascii/i\    import pytest\
        @pytest.mark.skip' flexget/tests/test_filesystem.py

    substituteInPlace requirements.txt --replace "sqlalchemy==1.1.10" "sqlalchemy"
    substituteInPlace requirements.txt --replace "chardet==3.0.3" "chardet"
  '';

  # Disable 3 failing tests caused by guessit upgrade
  # https://github.com/Flexget/Flexget/issues/1804
  checkPhase = ''
    export HOME=.
    py.test --disable-pytest-warnings
  '';

  buildInputs = [ pytest mock vcrpy pytest-catchlog boto3 ];
  propagatedBuildInputs = [
    feedparser sqlalchemy pyyaml
    beautifulsoup4 html5lib PyRSS2Gen pynzb
    rpyc jinja2 requests dateutil jsonschema
    pathpy guessit_2_0 APScheduler pytz
    terminaltables colorclass tempora
    cherrypy cheroot rebulk_0_8 portend
    flask flask-restful flask-restplus
    flask-compress flask_login flask-cors
    pyparsing safe future zxcvbn-python ]
  ++ lib.optional (pythonOlder "3.4") pathlib
  # enable deluge and transmission plugin support, if they're installed
  ++ lib.optional (config.deluge or false) deluge
  ++ lib.optional (transmission != null) transmissionrpc;

  meta = {
    homepage = https://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ domenkozar tari ];
  };
}
