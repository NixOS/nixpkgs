{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.50.35";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    tag = version;
    hash = "sha256-erSZ9hBrIhWTCuZP3C7lm3yxRv6z3ofYd5ceBGG8QYg=";
  };

  pythonRelaxDeps = true;

  propagatedBuildInputs =
    with python3.pkgs;
    [
      apprise
      beautifulsoup4
      brotli
      babel
      chardet
      cryptography
      dnspython
      elementpath
      eventlet
      extruct
      feedgen
      flask
      flask-compress
      flask-cors
      flask-expects-json
      flask-login
      flask-paginate
      flask-restful
      flask-wtf
      greenlet
      inscriptis
      jinja2
      jinja2-time
      jsonpath-ng
      jq
      loguru
      lxml
      paho-mqtt
      playwright
      pyee
      pyppeteer
      pytz
      requests
      selenium
      setuptools
      timeago
      urllib3
      validators
      werkzeug
      wtforms
    ]
    ++ requests.optional-dependencies.socks;

  # tests can currently not be run in one pytest invocation and without docker
  doCheck = false;

  nativeCheckInputs = with python3.pkgs; [
    pytest-flask
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Self-hosted free open source website change detection tracking, monitoring and notification service";
    homepage = "https://github.com/dgtlmoon/changedetection.io";
    changelog = "https://github.com/dgtlmoon/changedetection.io/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "changedetection.io";
  };
}
