{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fiduswriter";
  version = "4.1.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fiduswriter";
    repo = "fiduswriter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NkFJehSgwYwYUZaznZW63KEXR1wTf+Hpa+8ZM71aZ84=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" "setuptools"
  '';

  build-system = with python3Packages; [
    babel
    setuptools
  ];

  dependencies = with python3Packages; [
    bleach
    channels
    granian
    servestatic
    django_5
    django-allauth
    django-axes
    # django-avatar
    django-otp
    pyotp
    qrcode
    # django-js-error-hook
    # django-npm-mjs
    # django-loginas
    httpx
    httpx-ws
    pillow
    python-magic
    prosemirror
    # prosemirror-rs
    watchdog
    autobahn
  ];

  optional-dependencies = with python3Packages; {
    books = [
      fiduswriter-books
    ];
    citation-api-import = [
      fiduswriter-citation-api-import
    ];
    gitrepo-export = [
      fiduswriter-gitrepo-export
    ];
    languagetool = [
      fiduswriter-languagetool
    ];
    mysql = [
      mysqlclient
    ];
    ojs = [
      fiduswriter-ojs
    ];
    orjson = [
      orjson
    ];
    pandoc = [
      fiduswriter-pandoc
    ];
    payment-paddle = [
      fiduswriter-payment-paddle
    ];
    phplist = [
      fiduswriter-phplist
    ];
    postgresql = [
      psycopg2
    ];
    prosemirror-python = [
      prosemirror
    ];
    prosemirror-rust = [
      prosemirror-rs
    ];
    website = [
      fiduswriter-website
    ];
  };

  pythonRelaxDeps = [
    "granian"
    "pyotp"
    "httpx-ws"
  ];

  pythonImportsCheck = [
    "fiduswriter"
  ];

  meta = {
    description = "Online collaborative editor for academics";
    homepage = "https://github.com/fiduswriter/fiduswriter";
    changelog = "https://github.com/fiduswriter/fiduswriter/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "fiduswriter";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
