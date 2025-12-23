{
  lib,
  python3Packages,
  fetchFromGitHub,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "flexget";
  version = "3.17.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Flexget";
    repo = "Flexget";
    tag = "v${version}";
    hash = "sha256-Qfq6TXSNAnIq8m3I7noFe6pIq6PmUTQKUjN+ZC4NxyU=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = with python3Packages; [
    # See https://github.com/Flexget/Flexget/blob/master/pyproject.toml
    # and https://github.com/Flexget/Flexget/blob/develop/requirements.txt
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
    rarfile
    rebulk
    requests
    rich
    rpyc
    sqlalchemy
    zstandard
    pillow

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
    boto3
    libtorrent-rasterbar
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

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pytest-vcr
    python3Packages.pytest-xdist
    python3Packages.paramiko
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # reach the Internet
    "TestExistsMovie"
    "TestImdb"
    "TestImdbLookup"
    "TestImdbParser"
    "TestInputHtml"
    "TestInputSites"
    "TestNfoLookupWithMovies"
    "TestNpoWatchlistInfo"
    "TestNpoWatchlistLanguageTheTVDBLookup"
    "TestNpoWatchlistPremium"
    "TestPlex"
    "TestRadarrListActions"
    "TestRssOnline"
    "TestSeriesRootAPI"
    "TestSftpDownload"
    "TestSftpList"
    "TestSonarrListActions"
    "TestSubtitleList"
    "TestTMDBMovieLookupAPI"
    "TestTVDBEpisodeABSLookupAPI"
    "TestTVDBEpisodeAirDateLookupAPI"
    "TestTVDBEpisodeLookupAPI"
    "TestTVDBExpire"
    "TestTVDBFavorites"
    "TestTVDBLanguages"
    "TestTVDBList"
    "TestTVDBLookup"
    "TestTVDBLookup"
    "TestTVDBSeriesActorsLookupAPI"
    "TestTVDBSeriesLookupAPI"
    "TestTVDSearchIMDBLookupAPI"
    "TestTVDSearchNameLookupAPI"
    "TestTVDSearchZAP2ITLookupAPI"
    "TestTVMAzeSeriesLookupAPI"
    "TestTVMazeSeasonLookup"
    "TestTVMazeShowLookup"
    "TestTVMazeUnicodeLookup"
    "TestTaskParsing::test_selected_parser_cleared"
    "TestTheTVDBLanguages"
    "TestTheTVDBList"
    "TestTmdbLookup"
    "TestURLRewriters"
    "TestURLRewriters::test_ettv"
    # others
    "TestRegexp"
    "TestYamlLists"
  ];

  meta = {
    homepage = "https://flexget.com/";
    changelog = "https://github.com/Flexget/Flexget/releases/tag/${src.tag}";
    description = "Multipurpose automation tool for all of your media";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
