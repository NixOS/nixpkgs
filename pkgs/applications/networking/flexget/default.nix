{ lib, python
, delugeSupport ? true, deluge ? null
}:

assert delugeSupport -> deluge != null;

# Flexget have been a trouble maker in the past,
# if you see flexget breaking when updating packages, don't worry.
# The current state is that we have no active maintainers for this package.
# -- Mic92

let
  python' = python.override { inherit packageOverrides; };

  packageOverrides = self: super: {
    sqlalchemy = super.sqlalchemy.overridePythonAttrs (old: rec {
      version = "1.1.10";
      src = old.src.override {
        inherit version;
        sha256 = "1lvb14qclrx0qf6qqx8a8hkx5akk5lk3dvcqz8760v9hya52pnfv";
      };
    });
  };

in

with python'.pkgs;

buildPythonApplication rec {
  pname = "FlexGet";
  version = "2.13.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lkmxwy7k4zlcqpigwk8skc2zi8a70vrw21pz80wvmf9yg0wc9z9";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/==\([0-9]\.\?\)\+//' -i requirements.txt
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = [
    feedparser sqlalchemy pyyaml
    chardet beautifulsoup4 html5lib
    PyRSS2Gen pynzb rpyc jinja2
    jsonschema requests dateutil
    pathpy guessit_2_0 APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful
    flask-restplus flask-compress
    flask_login flask-cors safe
    pyparsing future zxcvbn-python
    werkzeug tempora cheroot rebulk
    portend transmissionrpc aniso8601
    babelfish certifi click futures
    idna itsdangerous markupsafe
    plumbum pytz six tzlocal urllib3
    webencodings werkzeug zxcvbn-python
  ] ++ lib.optional (pythonOlder "3.4") pathlib
    ++ lib.optional delugeSupport deluge;

  meta = with lib; {
    homepage    = https://flexget.com/;
    description = "Multipurpose automation tool for content like torrents";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
