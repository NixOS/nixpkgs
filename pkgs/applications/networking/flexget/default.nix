{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (old: rec {
        version = "1.4.47";
        src = self.fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-lfwC9/wfMZmqpHqKdXQ3E0z2GOnZlMhO/9U/Uww4WG8=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "flexget";
  version = "3.5.33";
  format = "pyproject";

  # Fetch from GitHub in order to use `requirements.in`
  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = "refs/tags/v${version}";
    hash = "sha256-LzDXNl2IQ3+j9uP+nE6JS8E+pO0n9zwmA7wrMeKR6Ms=";
  };

  postPatch = ''
    # remove dependency constraints but keep environment constraints
    sed 's/[~<>=][^;]*//' -i requirements.txt

    # "zxcvbn-python" was renamed to "zxcvbn", and we don't have the former in
    # nixpkgs. See: https://github.com/NixOS/nixpkgs/issues/62110
    substituteInPlace requirements.txt --replace "zxcvbn-python" "zxcvbn"
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = with python.pkgs; [
    # See https://github.com/Flexget/Flexget/blob/master/requirements.txt
    apscheduler
    beautifulsoup4
    click
    colorama
    commonmark
    feedparser
    guessit
    html5lib
    jinja2
    jsonschema
    loguru
    more-itertools
    packaging
    psutil
    pynzb
    pyrss2gen
    python-dateutil
    pyyaml
    rebulk
    requests
    rich
    rpyc
    sqlalchemy
    typing-extensions

    # WebUI requirements
    cherrypy
    flask-compress
    flask-cors
    flask-login
    flask-restful
    flask-restx
    flask
    pyparsing
    werkzeug
    zxcvbn

    # Plugins requirements
    transmission-rpc
  ];

  pythonImportsCheck = [
    "flexget"
  ];

  meta = with lib; {
    homepage = "https://flexget.com/";
    changelog = "https://github.com/Flexget/Flexget/releases/tag/v${version}";
    description = "Multipurpose automation tool for all of your media";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
