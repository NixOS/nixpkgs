{ lib
, python3
, python311
, fetchFromGitHub
}:

let
  python = if (builtins.tryEval python3.pkgs.nose.outPath).success
    then python3
    else python311;
in

python.pkgs.buildPythonApplication rec {
  pname = "flexget";
  version = "3.11.41";
  pyproject = true;

  # Fetch from GitHub in order to use `requirements.in`
  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZSqkD53fdDnKulVPgM9NWXVFXDR0sZ94mRyV1iKS87o=";
  };

  postPatch = ''
    # remove dependency constraints but keep environment constraints
    sed 's/[~<>=][^;]*//' -i requirements.txt
  '';

  build-system = with python.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python.pkgs; [
    # See https://github.com/Flexget/Flexget/blob/master/pyproject.toml
    apscheduler
    beautifulsoup4
    colorama
    feedparser
    guessit
    html5lib
    jinja2
    jsonschema
    loguru
    psutil
    pydantic
    pynzb
    pyrss2gen
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
    flask-login
    flask-restx
    flask
    packaging
    pyparsing
    werkzeug
    zxcvbn
    pendulum

    # Plugins requirements
    transmission-rpc
    qbittorrent-api
    deluge-client
    cloudscraper
    python-telegram-bot
  ];

  pythonImportsCheck = [
    "flexget"
    "flexget.api.core.authentication"
    "flexget.api.core.database"
    "flexget.api.core.plugins"
    "flexget.api.core.schema"
    "flexget.api.core.server"
    "flexget.api.core.tasks"
    "flexget.api.core.user"
    "flexget.components.thetvdb.api"
    "flexget.components.tmdb.api"
    "flexget.components.trakt.api"
    "flexget.components.tvmaze.api"
    "flexget.plugins.clients.aria2"
    "flexget.plugins.clients.deluge"
    "flexget.plugins.clients.nzbget"
    "flexget.plugins.clients.pyload"
    "flexget.plugins.clients.qbittorrent"
    "flexget.plugins.clients.rtorrent"
    "flexget.plugins.clients.transmission"
    "flexget.plugins.services.kodi_library"
    "flexget.plugins.services.myepisodes"
    "flexget.plugins.services.pogcal_acquired"
  ];

  # ~400 failures
  doCheck = false;

  meta = with lib; {
    homepage = "https://flexget.com/";
    changelog = "https://github.com/Flexget/Flexget/releases/tag/v${version}";
    description = "Multipurpose automation tool for all of your media";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
