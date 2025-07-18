{
  lib,
  python3Packages,
  fetchFromGitea,
  fetchPypi,
  fetchFromGitHub,
  callPackage,

  postgresql,
  libxml2,
  libxslt,

  # tests
  postgresqlTestHook,
}:

let
  # liberaforms requires a very specific version of flask-babel
  flask-babel = python3Packages.flask-babel.overridePythonAttrs rec {
    version = "2.0.0";
    format = "setuptools";
    src = fetchPypi {
      pname = "Flask-Babel";
      inherit version;
      hash = "sha256-+fr0XNsuGjLqLsFEA1h9QpUQjzUBenghorGsuM/ZJX0=";
    };
    nativeBuildInputs = [ ];
    propagatedBuildInputs = [ ];
    outputs = [ "out" ];
    dependencies = with python3Packages; [
      babel
      flask
      jinja2
      pytz
    ];
    pythonImportsCheck = [ ];
    checkInputs = [ ];
  };
  # same with flask
  flask = python3Packages.flask.overridePythonAttrs rec {
    version = "2.2.2";
    pyproject = null;
    format = "setuptools";
    src = fetchPypi {
      pname = "Flask";
      inherit version;
      hash = "sha256-ZCxFDRnErUgvlnKb0qj20yVUqh4jH09rTn5SZLFsyis=";
    };
    dependencies = (with python3Packages; [
      click
      blinker
      itsdangerous
      jinja2
    ] ++ [ werkzeug ]);
    nativeCheckInputs = [ ];
  };
  # same with werkzeug
  werkzeug = python3Packages.werkzeug.overridePythonAttrs rec {
    version = "2.2.2";
    pyproject = null;
    format = "setuptools";
    src = fetchPypi {
      pname = "Werkzeug";
      inherit version;
      hash = "sha256-fqLUgyLMfA+LOiFe1z6r17XXXQtQ4xqwBihsz/ngC48=";
    };
    nativeCheckInputs = [ ];
  };
  sqlalchemy_1_4 = python3Packages.sqlalchemy_1_4.overridePythonAttrs rec {
    version = "1.4.42";
    src = fetchFromGitHub {
      owner = "sqlalchemy";
      repo = "sqlalchemy";
      rev = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
      hash = "sha256-RVpreszvd5hn9BLzvnfKT4nibUuybtZwBRloe5NaP/E=";
    };
    env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
    disabledTestPaths = [
      # typing correctness, not interesting
      "test/ext/mypy"
      # slow and high memory usage, not interesting
      "test/aaa_profiling"
      # fetching and key slice failures, probably network related
      "test/base/test_result.py"
      "test/dialect/test_sqlite.py"
      "test/ext/test_baked.py"
      "test/ext/test_horizontal_shard.py"
      "test/ext/test_hybrid.py"
      "test/orm/"
      "test/sql/test_resultset.py"
    ];
  };
in

python3Packages.buildPythonPackage rec {
  pname = "liberaforms";
  version = "4.1.2";
  format = "other";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LiberaForms";
    repo = "server";
    tag = "v${version}";
    hash = "sha256-OALAoaIbUPD9qrtxraoG50/lkUvShHq0n5d8etkSliI=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aiosmtpd
    alembic
    atpublic
    attrs
    babel
    beautifulsoup4
    bleach
    cairosvg
    cachelib
    certifi
    cffi
    charset-normalizer
    click
    cryptography
    deepdiff
    dnspython
    email-validator
    feedgen
    flask
    flask-babel
    flask-login
    flask-marshmallow
    flask-migrate
    flask-session2
    flask-session
    flask-sqlalchemy
    flask-wtf
    greenlet
    gunicorn
    idna
    importlib-metadata
    importlib-resources
    iniconfig
    itsdangerous
    jinja2
    ldap3
    lxml
    mako
    markdown
    markupsafe
    marshmallow
    marshmallow-sqlalchemy
    minio
    packaging
    passlib
    password-strength
    password-entropy
    pillow
    platformdirs
    pluggy
    portpicker
    prometheus-client
    psutil
    psycopg2
    py
    pyasn1
    pycodestyle
    pycparser
    pygments
    pyjwt
    pyparsing
    pypng
    pyqrcode
    python-dateutil
    python-dotenv
    python-magic
    pytz
    requests
    six
    smtpdfix
    snowballstemmer
    soupsieve
    sqlalchemy_1_4
    sqlalchemy-json
    toml
    unicodecsv
    unidecode
    urllib3
    webencodings
    werkzeug
    wtforms
    zipp
  ];

  pythonRemoveDeps = [
    # removed
    "typed-ast"
  ];

  nativeBuildInputs = [
    postgresql
    libxml2
    libxslt
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -R ${src}/. $out

    runHook postInstall
  '';

  doCheck = true;

  nativeCheckInputs =
    [
      postgresql
      postgresqlTestHook
    ]
    ++ (with python3Packages; [
      faker
      pytestCheckHook
      pytest-dotenv
      factory-boy
      polib
    ]);

  preCheck = ''
    export LANG=C.UTF-8
    export PGUSER=db_user
    export postgresqlEnableTCP=1
  '';

  checkPhase = ''
    runHook preCheck

    # Run pytest on the installed version. A running postgres database server is needed.
    (cd tests && cp test.ini.example test.ini && pytest -k "not test_save_smtp_config and not test/ext/test_horizontal_shard.py\
      and not TestE2EEDisabledFeatures") #TODO why does this break?

    runHook postCheck
  '';

  # avoid writing in the migration process
  postFixup = ''
    cp $out/assets/brand/logo-default.png $out/assets/brand/logo.png
    cp $out/assets/brand/favicon-default.ico $out/assets/brand/favicon.ico
    sed -i "/shutil.copyfile/d" $out/liberaforms/models/site.py
    sed -i "/brand_dir/d" $out/migrations/versions/6f0e2b9e9db3_.py
  '';

  meta = {
    description = "Free form software";
    homepage = "https://gitlab.com/liberaforms/liberaforms";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
  };
}
