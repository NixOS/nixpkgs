{ lib
, fetchFromGitHub
, python
, transmission
, deluge
, config
}:

with python.pkgs;

buildPythonApplication rec {
  version = "2.10.82";
  name = "FlexGet-${version}";

  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = version;
    sha256 = "15508ihswfjbkzhf1f0qhn2ar1aiibz2ggp5d6r33icy8xwhpv09";
  };

  doCheck = true;
  # test_regexp requires that HOME exist, test_filesystem requires a
  # unicode-capable filesystem (and setting LC_ALL doesn't work).
  # setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  postPatch = ''
    sed -i '/def test_non_ascii/i\    import pytest\
        @pytest.mark.skip' flexget/tests/test_filesystem.py

    substituteInPlace requirements.txt \
      --replace "chardet==3.0.3" "chardet" \
      --replace "rebulk==0.8.2" "rebulk" \
      --replace "cherrypy==10.2.2" "cherrypy" \
      --replace "portend==1.8" "portend" \
      --replace "sqlalchemy==1.1.10" "sqlalchemy" \
      --replace "zxcvbn-python==4.4.15" "zxcvbn-python" \
      --replace "flask-cors==3.0.2" "flask-cors" \
      --replace "certifi==2017.4.17" "certifi" \
      --replace "cheroot==5.5.0" "cheroot" \
      --replace "plumbum==1.6.3" "plumbum" \
  '';

  checkPhase = ''
    export HOME=.
    py.test --disable-pytest-warnings -k "not test_quality_failures \
                                          and not test_group_quality \
                                          and not crash_report \
                                          and not test_multi_episode \
                                          and not test_double_episodes \
                                          and not test_inject_force \
                                          and not test_double_prefered \
                                          and not test_double"
  '';

  buildInputs = [ pytest mock vcrpy pytest-catchlog boto3 ];
  propagatedBuildInputs = [
    feedparser sqlalchemy pyyaml chardet
    beautifulsoup4 html5lib PyRSS2Gen pynzb
    rpyc jinja2 jsonschema requests dateutil jsonschema
    pathpy guessit_2_0 APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful flask-restplus
    flask-compress flask_login flask-cors
    pyparsing safe future zxcvbn-python
    werkzeug tempora cheroot rebulk portend
  ] ++ lib.optional (pythonOlder "3.4") pathlib
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
