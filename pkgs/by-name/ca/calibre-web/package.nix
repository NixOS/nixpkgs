{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "calibre-web";
  version = "0.6.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "janeczku";
    repo = "calibre-web";
    tag = version;
    hash = "sha256-tmSp6ABQ4KnNdUHYZPnXGfhhyhM6aczEUPd57APZnLA=";
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

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
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
    comics = with python3Packages; [
      comicapi
      natsort
    ];

    gdrive = with python3Packages; [
      gevent
      google-api-python-client
      greenlet
      httplib2
      oauth2client
      pyasn1-modules
      # https://github.com/NixOS/nixpkgs/commit/bf28e24140352e2e8cb952097febff0e94ea6a1e
      # pydrive2
      pyyaml
      rsa
      uritemplate
    ];

    gmail = with python3Packages; [
      google-api-python-client
      google-auth-oauthlib
    ];

    # We don't support the goodreads feature, as the `goodreads` package is
    # archived and depends on other long unmaintained packages (rauth & nose)
    # goodreads = [ ];

    kobo = with python3Packages; [ jsonschema ];

    ldap = with python3Packages; [
      flask-simpleldap
      python-ldap
    ];

    metadata = with python3Packages; [
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

    oauth = with python3Packages; [
      flask-dance
      sqlalchemy-utils
    ];
  };

  pythonRelaxDeps = [
    "apscheduler"
    "bleach"
    "cryptography"
    "flask"
    "flask-limiter"
    "lxml"
    "pypdf"
    "regex"
    "tornado"
    "unidecode"
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
    changelog = "https://github.com/janeczku/calibre-web/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pborzenkov ];
    mainProgram = "calibre-web";
    platforms = lib.platforms.all;
  };
}
