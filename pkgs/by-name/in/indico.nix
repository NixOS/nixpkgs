{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "indico";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "indico";
    repo = "indico";
    rev = "v${version}";
    hash = "sha256-u2PUZjcyQSMn3ImKtTcwYoD68oAlrKXo8EksOHhsNiM=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    alembic
    amqp
    asttokens
    async-timeout
    attrs
    authlib
    babel
    bcrypt
    billiard
    bleach
    blinker
    brotli
    cachelib
    cachetools
    captcha
    celery
    certifi
    cffi
    chardet
    charset-normalizer
    click
    click-didyoumean
    click-plugins
    click-repl
    colorclass
    cryptography
    cssselect2
    decorator
    deprecated
    distro
    dnspython
    email-validator
    executing
    feedgen
    flask
    flask-babel
    flask-caching
    flask-cors
    flask-limiter
    flask-marshmallow
    flask-migrate
    flask-multipass
    flask-pluginengine
    flask-sqlalchemy
    flask-webpackext
    flask-wtf
    fonttools
    google-auth
    greenlet
    hiredis
    html2text
    html5lib
    icalendar
    idna
    importlib-metadata
    importlib-resources
    indico-fonts
    ipython
    itsdangerous
    jedi
    jinja2
    jsonschema
    jsonschema-specifications
    kombu
    limits
    lxml
    mako
    markdown
    markdown-it-py
    markupsafe
    marshmallow
    marshmallow-dataclass
    marshmallow-enum
    marshmallow-oneofschema
    marshmallow-sqlalchemy
    matplotlib-inline
    mdurl
    mypy-extensions
    ordered-set
    packaging
    parso
    pexpect
    pillow
    prompt-toolkit
    psycopg2
    ptyprocess
    pure-eval
    pyasn1
    pyasn1-modules
    pycountry
    pycparser
    pydyf
    pygments
    pynpm
    pypdf
    pyphen
    pypng
    python-dateutil
    pytz
    pywebpack
    pyyaml
    qrcode
    redis
    referencing
    reportlab
    requests
    rich
    rpds-py
    rsa
    sentry-sdk
    simplejson
    six
    speaklater
    sqlalchemy
    stack-data
    terminaltables
    tinycss2
    traitlets
    translitcodec
    typing-extensions
    typing-inspect
    tzdata
    ua-parser
    urllib3
    vine
    wcwidth
    weasyprint
    webargs
    webencodings
    werkzeug
    wrapt
    wtforms
    wtforms-dateutil
    wtforms-sqlalchemy
    xlsxwriter
    zipp
    zopfli
  ];

  pythonImportsCheck = [ "indico" ];

  meta = {
    description = "Indico - A feature-rich event management system, made @ CERN, the place where the Web was born";
    homepage = "https://github.com/indico/indico";
    changelog = "https://github.com/indico/indico/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thubrecht ];
    mainProgram = "indico";
  };
}
