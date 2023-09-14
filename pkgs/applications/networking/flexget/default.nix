{ lib
, python3
, fetchPypi
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "flexget";
  version = "3.9.9";
  format = "pyproject";

  # Fetch from GitHub in order to use `requirements.in`
  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = "refs/tags/v${version}";
    hash = "sha256-kZ+RHkqmmRd7Ew5u8/SQADzOUa9YwCsj+nmtthCDlDw=";
  };

  postPatch = ''
    # remove dependency constraints but keep environment constraints
    sed 's/[~<>=][^;]*//' -i requirements.txt
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
    pyrsistent
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
    "flexget.plugins.clients.transmission"
  ];

  # ~400 failures
  doCheck = false;

  meta = with lib; {
    homepage = "https://flexget.com/";
    changelog = "https://github.com/Flexget/Flexget/releases/tag/v${version}";
    description = "Multipurpose automation tool for all of your media";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
