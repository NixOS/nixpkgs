{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "flexget";
  version = "3.5.31";
  format = "pyproject";

  # Fetch from GitHub in order to use `requirements.in`
  src = fetchFromGitHub {
    owner = "flexget";
    repo = "flexget";
    rev = "refs/tags/v${version}";
    hash = "sha256-v6N1isaTVPwV/LC/a2lzrboLI6V/4W586RE5esfR500=";
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

  propagatedBuildInputs = with python3Packages; [
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
