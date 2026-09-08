{
  lib,
  fetchFromGitHub,
  python3,
  gitUpdater,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.54.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    tag = version;
    hash = "sha256-Bn4o6/fVaf7BfpZm9HIP4ApAu8s3fvNcIutGlsEtCKk=";
  };

  pythonRelaxDeps = true;

  propagatedBuildInputs =
    with python3.pkgs;
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
      levenshtein
      linkify-it-py
      loguru
      lxml
      openapi-core
      openpyxl
      orjson
      paho-mqtt
      panzi-json-logic
      pluggy
      price-parser
      puremagic
      pyppeteer-ng
      # pyppeteerstealth # Optional for changedetection-io and not packaged.
      python-engineio
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

  nativeInstallCheckInputs = with python3.pkgs; [
    pytestCheckHook
    psutil
    pytest
    pytest-flask
    pytest-mock
    pytest-xdist
  ];

  # Some simple tests can be run without network IO.
  # Namely tests that don't have a dependency on the `live_server` fixture.
  enabledTestPaths = [
    "changedetectionio/tests/unit/test_html_to_text.py"
    "changedetectionio/tests/unit/test_jinja2_security.py"
    "changedetectionio/tests/unit/test_notification_diff.py"
    "changedetectionio/tests/unit/test_restock_logic.py"
    "changedetectionio/tests/unit/test_scheduler.py"
    "changedetectionio/tests/unit/test_semver.py"
    "changedetectionio/tests/unit/test_time_extension.py"
    "changedetectionio/tests/unit/test_time_handler.py"
    "changedetectionio/tests/unit/test_watch_model.py"
    "changedetectionio/tests/test_html_to_text.py"
    "changedetectionio/tests/test_xpath_default_namespace.py"
    "changedetectionio/tests/test_xpath_selector_unit.py"
  ];

  pythonImportsCheck = [ "changedetectionio" ];

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      inherit (nixosTests) changedetection-io;
    };
  };

  meta = {
    description = "Self-hosted free open source website change detection tracking, monitoring and notification service";
    homepage = "https://github.com/dgtlmoon/changedetection.io";
    changelog = "https://github.com/dgtlmoon/changedetection.io/releases/tag/${src.tag}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      mikaelfangel
      thanegill
    ];
    mainProgram = "changedetection.io";
  };
}
