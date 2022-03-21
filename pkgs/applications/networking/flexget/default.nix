{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "flexget";
  version = "3.3.3";

  # Fetch from GitHub in order to use `requirements.in`
  src = fetchFromGitHub {
    owner = "flexget";
    repo = "flexget";
    rev = "v${version}";
    hash = "sha256-a76x4Klad3lct2M9RxSroUYKmEX7lPqDN+dFvfjavo8=";
  };

  postPatch = ''
    # Symlink requirements.in because upstream uses `pip-compile` which yields
    # python-version dependent requirements
    ln -sf requirements.in requirements.txt

    # remove dependency constraints
    sed 's/[>=]=.*//' -i requirements.txt

    # "zxcvbn-python" was renamed to "zxcvbn", and we don't have the former in
    # nixpkgs. See: https://github.com/NixOS/nixpkgs/issues/62110
    substituteInPlace requirements.txt --replace "zxcvbn-python" "zxcvbn"
  '';

  # ~400 failures
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
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
