{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FlexGet";
  version = "3.1.59";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "19vp2395sl6gdv54zn0k4vf1j6b902khvm44q5hfr805jd3fc11h";
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

  propagatedBuildInputs = with python3Packages; [
    # See https://github.com/Flexget/Flexget/blob/master/requirements.in
    APScheduler
    beautifulsoup4
    cherrypy
    colorclass
    feedparser
    flask-compress
    flask-cors
    flask_login
    flask-restful
    flask-restplus
    flask
    guessit
    html5lib
    jinja2
    jsonschema
    loguru
    more-itertools
    progressbar
    pynzb
    pyparsing
    PyRSS2Gen
    dateutil
    pyyaml
    rebulk
    requests
    rpyc
    sqlalchemy
    terminaltables
    zxcvbn
    # plugins
    transmissionrpc
  ];

  meta = with lib; {
    homepage    = "https://flexget.com/";
    description = "Multipurpose automation tool for all of your media";
    license     = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
