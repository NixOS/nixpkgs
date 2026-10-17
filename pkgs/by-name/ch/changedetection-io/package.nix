{
  lib,
  fetchFromGitHub,
  python3Packages,
  stdenv,
  gitUpdater,
  testers,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "changedetection-io";
  version = "0.60.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    tag = finalAttrs.version;
    hash = "sha256-gbZEnSBRuLUexuNWNka6K/NY3mwy6Dujx3y/y+7fqaA=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonRelaxDeps = [
    "apprise"
    "beautifulsoup4"
    "chardet"
    "cryptography"
    "flask_wtf"
    "pyppeteer-ng"
    "selenium"
    "werkzeug"
  ];

  pythonRemoveDeps = [
    "pyppeteerstealth"
    "pytest"
    "pytest-flask"
    "pytest-mock"
    "pytest-xdist"
  ];

  dependencies =
    with python3Packages;
    [
      apprise
      arrow
      babel
      beautifulsoup4
      blinker
      brotli
      chardet
      cryptography
      diff-match-patch
      elementpath
      extruct
      feedgen
      feedparser
      flask
      flask-babel
      flask-compress
      flask-cors
      flask-login
      flask-paginate
      flask-restful
      flask-socketio
      flask-wtf
      gevent
      greenlet
      inscriptis
      jinja2
      jq
      jsonpath-ng
      jsonschema
      linkify-it-py
      litellm
      loguru
      lxml
      openapi-core
      openpyxl
      orjson
      paho-mqtt
      panzi-json-logic
      playwright
      pluggy
      price-parser
      psutil
      puremagic
      pydantic
      pyppeteer-ng
      python-engineio
      python-socketio
      pytz
      rank-bm25
      rapidfuzz
      referencing
      requests
      requests-file
      segno
      selenium
      timeago
      tzdata
      validators
      werkzeug
      wtforms
    ]
    ++ requests.optional-dependencies.socks
    ++ openapi-core.optional-dependencies.flask;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-flask
    pytest-mock
    pytest-xdist
  ];

  # pytest-flask's live_server fixture binds a local port.
  __darwinAllowLocalNetworking = true;

  enabledTestPaths = [ "changedetectionio/tests/unit" ];

  pythonImportsCheck = [
    "changedetectionio"
    "changedetectionio.flask_app"
    "changedetectionio.model.LLMSettings"
  ];

  passthru = {
    updateScript = gitUpdater { };
    tests = import ./tests {
      inherit lib stdenv testers;
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Self-hosted free open source website change detection tracking, monitoring and notification service";
    homepage = "https://github.com/dgtlmoon/changedetection.io";
    changelog = "https://github.com/dgtlmoon/changedetection.io/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mikaelfangel
      thanegill
    ];
    mainProgram = "changedetection.io";
  };
})
