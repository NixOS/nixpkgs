{
  lib,
  fetchFromGitHub,
  python3,
  gitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.51.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    tag = version;
    hash = "sha256-Qm3dI5ZHkLK3hTsadnzIDdmeiDM/QovGw2FZDVml5tE=";
  };

  pythonRelaxDeps = true;

  propagatedBuildInputs =
    with python3.pkgs;
    [
      apprise
      babel
      beautifulsoup4
      blinker
      brotli
      chardet
      cryptography
      elementpath
      extruct
      feedgen
      flask
      flask-compress
      flask-cors
      flask-expects-json
      flask-login
      flask-paginate
      flask-restful
      flask-socketio
      flask-wtf
      gevent
      greenlet
      inscriptis
      janus
      jinja2
      jinja2-time
      jq
      jsonpath-ng
      jsonschema
      levenshtein
      loguru
      lxml
      openapi-core
      openpyxl
      paho-mqtt
      panzi-json-logic
      pluggy
      price-parser
      psutil
      pyppeteer-ng
      # pyppeteerstealth
      python-engineio
      python-magic
      python-socketio
      pytz
      referencing
      requests
      requests-file
      selenium
      timeago
      tzdata
      validators
      werkzeug
      wtforms
    ]
    ++ requests.optional-dependencies.socks
    ++ openapi-core.optional-dependencies.flask;

  # tests can currently not be run in one pytest invocation and without docker
  doCheck = false;

  pythonImportsCheck = [ "changedetectionio" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Self-hosted free open source website change detection tracking, monitoring and notification service";
    homepage = "https://github.com/dgtlmoon/changedetection.io";
    changelog = "https://github.com/dgtlmoon/changedetection.io/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mikaelfangel
      thanegill
    ];
    mainProgram = "changedetection.io";
  };
}
