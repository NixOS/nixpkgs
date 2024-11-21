{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  python311,
}:

let
  # `atheris` is broken on Python >= 3.12
  python = python311;
in
python.pkgs.buildPythonApplication rec {
  pname = "calibre-web";
  version = "0.6.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "janeczku";
    repo = "calibre-web";
    rev = "refs/tags/${version}";
    hash = "sha256-DYhlD3ly6U/e5cDlsubDyW1uKeCtB+HrpagJlNDJhyI=";
  };

  patches = [
    # default-logger.patch switches default logger to /dev/stdout. Otherwise calibre-web tries to open a file relative
    # to its location, which can't be done as the store is read-only. Log file location can later be configured using UI
    # if needed.
    ./default-logger.patch
    # DB migrations adds an env var __RUN_MIGRATIONS_ANDEXIT that, when set, instructs calibre-web to run DB migrations
    # and exit. This is gonna be used to configure calibre-web declaratively, as most of its configuration parameters
    # are stored in the DB.
    ./db-migrations.patch
  ];

  # calibre-web doesn't follow setuptools directory structure.
  postPatch = ''
    mkdir -p src/calibreweb
    mv cps.py src/calibreweb/__init__.py
    mv cps src/calibreweb

    substituteInPlace pyproject.toml \
      --replace-fail 'cps = "calibreweb:main"' 'calibre-web = "calibreweb:main"'
  '';

  build-system = [ python.pkgs.setuptools ];

  dependencies = with python.pkgs; [
    apscheduler
    babel
    bleach
    chardet
    cryptography
    flask
    flask-babel
    flask-httpauth
    flask-limiter
    flask-principal
    flask-wtf
    iso-639
    lxml
    netifaces-plus
    pycountry
    pypdf
    python-magic
    pytz
    regex
    requests
    sqlalchemy
    tornado
    unidecode
    urllib3
    wand
  ];

  optional-dependencies = {
    comics = with python.pkgs; [
      comicapi
      natsort
    ];

    gdrive = with python.pkgs; [
      gevent
      google-api-python-client
      greenlet
      httplib2
      oauth2client
      pyasn1-modules
      pydrive2
      pyyaml
      rsa
      uritemplate
    ];

    gmail = with python.pkgs; [
      google-api-python-client
      google-auth-oauthlib
    ];

    # We don't support the goodreads feature, as the `goodreads` package is
    # archived and depends on other long unmaintained packages (rauth & nose)
    # goodreads = [ ];

    kobo = with python.pkgs; [ jsonschema ];

    ldap = with python.pkgs; [
      flask-simpleldap
      python-ldap
    ];

    metadata = with python.pkgs; [
      faust-cchardet
      html2text
      markdown2
      mutagen
      py7zr
      pycountry
      python-dateutil
      rarfile
      scholarly
    ];

    oauth = with python.pkgs; [
      flask-dance
      sqlalchemy-utils
    ];
  };

  pythonRelaxDeps = [
    "lxml"
    "pypdf"
    "regex"
  ];

  nativeCheckInputs = lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "calibreweb" ];

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux { inherit (nixosTests) calibre-web; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web app for browsing, reading and downloading eBooks stored in a Calibre database";
    homepage = "https://github.com/janeczku/calibre-web";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pborzenkov ];
    platforms = lib.platforms.all;
    mainProgram = "calibre-web";
  };
}
