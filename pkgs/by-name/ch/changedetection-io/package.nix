{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  nixosTests,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "changedetection-io";
  version = "0.70.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    tag = finalAttrs.version;
    hash = "sha256-Y+Fmhyj3jAisMNkp7p1baKt246v+T1Uw5JXfStNOQyQ=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Optional, upstream skips it when missing; not packaged
    "pyppeteerstealth"
    # Listed in requirements.txt so users can run the test suite
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
      authlib
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
      mcp-types
      openapi-core
      openpyxl
      orjson
      paho-mqtt
      panzi-json-logic
      # Not in requirements.txt, but the Playwright fetcher imports it
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
      regex
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

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytest-flask
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ]);

  # Upstream's unit test stage; the rest of the suite needs a live server
  # per test file and network access.
  enabledTestPaths = [
    "changedetectionio/tests/unit"
    "changedetectionio/tests/llm"
  ];

  # The autouse live_server fixture binds a socket for every test.
  __darwinAllowLocalNetworking = true;

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [
    "changedetectionio"
    "changedetectionio.flask_app"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) changedetection-io; };
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
