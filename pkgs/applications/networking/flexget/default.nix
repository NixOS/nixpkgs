{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.2.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-yKhbKNN3zHc35G4tnytPRO48Dh3qxr9G3e/HGH0weXo=";
        };

        SETUPTOOLS_SCM_PRETEND_VERSION = version;

        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "flexget";
  version = "3.2.18";
  format = "setuptools";

  # Fetch from GitHub in order to use `requirements.in`
  src = fetchFromGitHub {
    owner = "flexget";
    repo = "flexget";
    rev = "v${version}";
    sha256 = "sha256-68tD7I7MI/Cp94tp6c4lQx+8xwRnJTKTF/3SWz4Ddgg=";
  };

  postPatch = ''
    # Symlink requirements.in because upstream uses `pip-compile` which yields
    # python-version dependent requirements
    ln -sf requirements.in requirements.txt

    # remove dependency constraints
    sed 's/==\([0-9]\.\?\)\+//' -i requirements.txt

    # "zxcvbn-python" was renamed to "zxcvbn", and we don't have the former in
    # nixpkgs. See: https://github.com/NixOS/nixpkgs/issues/62110
    substituteInPlace requirements.txt --replace "zxcvbn-python" "zxcvbn"
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = with py.pkgs; [
    # See https://github.com/Flexget/Flexget/blob/master/requirements.in
    APScheduler
    beautifulsoup4
    feedparser
    guessit
    html5lib
    jinja2
    jsonschema
    loguru
    more-itertools
    psutil
    pynzb
    PyRSS2Gen
    python-dateutil
    pyyaml
    rebulk
    requests
    rich
    rpyc
    sqlalchemy

    # WebUI requirements
    cherrypy
    flask-compress
    flask-cors
    flask_login
    flask-restful
    flask-restx
    flask
    pyparsing
    zxcvbn

    # Plugins requirements
    transmission-rpc
  ];

  meta = with lib; {
    homepage = "https://flexget.com/";
    description = "Multipurpose automation tool for all of your media";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
