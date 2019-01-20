{ lib, python36 }:

# Flexget have been a trouble maker in the past,
# if you see flexget breaking when updating packages, don't worry.
# The current state is that we have no active maintainers for this package.
# -- Mic92

let
  python' = python36.override { inherit packageOverrides; };

  packageOverrides = self: super: {
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
    sha256 = "a09ef9482ed54f7e96eb8b4d08c59687c5c43a3341c9d2675383693e6c3681c3";
  };

  postPatch = ''
    # build for the correct python version
    substituteInPlace setup.cfg --replace $'[bdist_wheel]\npython-tag = py27' ""
    # remove dependency constraints
    sed 's/==\([0-9]\.\?\)\+//' -i requirements.txt
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = [
    # See https://github.com/Flexget/Flexget/blob/master/requirements.in
    feedparser sqlalchemy pyyaml
    beautifulsoup4 html5lib
    PyRSS2Gen pynzb rpyc jinja2
    requests dateutil jsonschema
    pathpy guessit APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful
    flask-restplus flask-compress
    flask_login flask-cors
    pyparsing zxcvbn-python future
    # Optional requirements
    deluge-client
    # Plugins
    transmissionrpc
  ] ++ lib.optional (pythonOlder "3.4") pathlib;

  meta = with lib; {
    homepage    = https://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
