{ lib, python3 }:

# Flexget have been a trouble maker in the past,
# if you see flexget breaking when updating packages, don't worry.
# The current state is that we have no active maintainers for this package.
# -- Mic92

let
  python' = python3.override { inherit packageOverrides; };

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
  version = "2.21.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l77fgg0w5dca1bwk4fcc1yz1g7njb0x07yx4bazyg821gl15rc9";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/==\([0-9]\.\?\)\+//' -i requirements.txt

    # "zxcvbn-python" was renamed to "zxcvbn", and we don't have the former in
    # nixpkgs. See: https://github.com/NixOS/nixpkgs/issues/62110
    substituteInPlace requirements.txt --replace "zxcvbn-python" "zxcvbn"
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = [
    # See https://github.com/Flexget/Flexget/blob/master/requirements.in
    feedparser sqlalchemy pyyaml
    beautifulsoup4 html5lib
    PyRSS2Gen pynzb rpyc jinja2
    requests dateutil jsonschema
    pathpy guessit rebulk APScheduler
    terminaltables colorclass
    cherrypy flask flask-restful
    flask-restplus flask-compress
    flask_login flask-cors
    pyparsing zxcvbn future
    progressbar
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
