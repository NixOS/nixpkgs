{ lib
, fetchFromGitHub
, python
, transmission
, deluge
, config
}:

with python.pkgs;

buildPythonApplication rec {
  version = "2.10.40";
  name = "FlexGet-${version}";

  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = version;
    sha256 = "0hh21yv1lvdfi198snwjabfsdh04fnpjszpgg28wvg5pd1qq8lqv";
  };

  doCheck = true;
  # test_regexp requires that HOME exist, test_filesystem requires a
  # unicode-capable filesystem (and setting LC_ALL doesn't work).
  # setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  postPatch = ''
    sed -i '/def test_non_ascii/i\    import pytest\
        @pytest.mark.skip' flexget/tests/test_filesystem.py

    substituteInPlace requirements.txt --replace "guessit<=2.0.4" "guessit"
  '';

  # Disable 3 failing tests caused by guessit upgrade
  # https://github.com/Flexget/Flexget/issues/1804
  checkPhase = ''
    export HOME=.
    py.test --disable-pytest-warnings -k "not test_date_options and not test_ep_as_quality and not testFromGroup"
  '';

  buildInputs = [ pytest mock vcrpy pytest-catchlog boto3 ];
  propagatedBuildInputs = [
    feedparser sqlalchemy pyyaml
    beautifulsoup4 html5lib PyRSS2Gen pynzb
    rpyc jinja2 requests dateutil jsonschema
    pathpy guessit APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful flask-restplus_0_8
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
