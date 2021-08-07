{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "flexget";
  version = "3.1.133";

  src = python3Packages.fetchPypi {
    pname = "FlexGet";
    inherit version;
    sha256 = "1mfmy2nbxx9k6hnhwxpf2062rwspigfhbvkpr161grd5amcs2cr6";
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
    colorama
    colorclass
    feedparser
    flask-compress
    flask-cors
    flask_login
    flask-restful
    flask-restx
    flask
    greenlet
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
    python-dateutil
    pyyaml
    rebulk
    requests
    rpyc
    sgmllib3k
    sqlalchemy
    terminaltables
    zxcvbn
    psutil
    # plugins
    transmission-rpc
  ];

  meta = with lib; {
    homepage = "https://flexget.com/";
    description = "Multipurpose automation tool for all of your media";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
