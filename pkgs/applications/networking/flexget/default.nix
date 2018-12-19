{ lib, python36, python27
, delugeSupport ? true, deluge ? null
}:

assert delugeSupport -> deluge != null;

# Flexget have been a trouble maker in the past,
# if you see flexget breaking when updating packages, don't worry.
# The current state is that we have no active maintainers for this package.
# -- Mic92

let
  python' = python36.override { inherit packageOverrides; };

  packageOverrides = self: super: {
    sqlalchemy = super.sqlalchemy.overridePythonAttrs (old: rec {
      version = "1.2.6";
      src = old.src.override {
        inherit version;
        sha256 = "1nwylglh256mbwwnng6n6bzgxshyz18j12hw76sghbprp74hrc3w";
      };
    });

    guessit = super.guessit.overridePythonAttrs (old: rec {
      version = "3.0.3";
      src = old.src.override {
        inherit version;
        sha256 = "1q06b3k31bfb8cxjimpf1rkcrwnc596a9cppjw15minvdangl32r";
      };
    });
  };

in

with python'.pkgs;

buildPythonApplication rec {
  pname = "FlexGet";
  version = "2.17.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hw16rn3wsc3adkx5ja16cxc9ic7jv2hhkcbxfb7wkym5r4gk7m0";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/==\([0-9]\.\?\)\+//' -i requirements.txt
    # Set python to 3.6
    sed -i -e 's/py27/py36/g' setup.cfg
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = [
    python27
    feedparser sqlalchemy pyyaml
    chardet beautifulsoup4 html5lib
    PyRSS2Gen pynzb rpyc jinja2
    jsonschema requests dateutil
    pathpy guessit APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful
    flask-restplus flask-compress
    flask_login flask-cors safe
    pyparsing zxcvbn-python
    werkzeug tempora cheroot rebulk
    portend transmissionrpc aniso8601
    babelfish certifi click future
    idna itsdangerous markupsafe
    plumbum pytz six tzlocal urllib3
    webencodings werkzeug zxcvbn-python
    backports_functools_lru_cache
  ] ++ lib.optional (pythonOlder "3.4") pathlib
    ++ lib.optional delugeSupport deluge;

  meta = with lib; {
    homepage    = https://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
