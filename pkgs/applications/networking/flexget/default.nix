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

    guessit = super.guessit.overridePythonAttrs (old: rec {
      version = "2.1.4";
      src = old.src.override {
        inherit version;
        sha256 = "90e6f9fb49246ad27f34f8b9984357e22562ccc3059241cbc08b4fac1d401c56";
      };
    });
  };

in

with python'.pkgs;

buildPythonApplication rec {
  pname = "FlexGet";
  version = "2.14.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pyvm1d23qy71rg7fzxcal8978kni7sn09zw4s4dsq56g8w80ay9";
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
    pathpy guessit APScheduler
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
