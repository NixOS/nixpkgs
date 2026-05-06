{
  lib,
  python3,
  fetchFromGitea,
  fetchFromGitHub,
  fetchPypi,

  moreutils,
  dart-sass,
  postgresql,
  libxml2,
  libxslt,

  # tests
  postgresqlTestHook,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # required 1.8.1 (tests fail otherwise)
      alembic = super.alembic.overridePythonAttrs rec {
        pname = "alembic";
        version = "1.8.1";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-zQteRbFLcGQmuDPwY2m5ptXuA/gm7DI4cjzoyq9uX/o=";
        };
        doCheck = false;
      };
      # required 3.1.0 (requirements and 3.1.0 works with alembic 1.8.1)
      flask-migrate = super.flask-migrate.overridePythonAttrs rec {
        version = "3.1.0";
        src = fetchFromGitHub {
          owner = "miguelgrinberg";
          repo = "Flask-Migrate";
          tag = "v${version}";
          hash = "sha256-2P9UfR/1Vv9FSmpSZn0gV4/uuSNdl6sdgRnSbefFR34=";
        };
        dependencies = [
          self.alembic
          super.flask
          self.flask-sqlalchemy
        ];
        nativeCheckInputs = [ ];
      };
      # required downgrade to 3.0.2 (from requirements.txt as well as sqlalchemy downgrade)
      flask-sqlalchemy = super.flask-sqlalchemy.overridePythonAttrs rec {
        version = "3.0.2";
        src = fetchPypi {
          pname = "Flask-SQLAlchemy";
          inherit version;
          hash = "sha256-FhmfWz3ftp4N8vUq5Mdq7b/sgjRiNJ2rshobLgorZek=";
        };
        dependencies = [
          super.flask
          self.sqlalchemy
          super.pdm-pep517
        ];
      };
      # required 1.4.42 (from requirements)
      sqlalchemy = super.sqlalchemy_1_4.overridePythonAttrs rec {
        version = "1.4.42";
        src = fetchFromGitHub {
          owner = "sqlalchemy";
          repo = "sqlalchemy";
          rev = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
          hash = "sha256-RVpreszvd5hn9BLzvnfKT4nibUuybtZwBRloe5NaP/E=";
        };
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

    };
  };
  python3Packages = python.pkgs;
in

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "liberaforms";
  version = "4.8.0";
  format = "other";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LiberaForms";
    repo = "server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F8vs62CiOC5e8rCxoFLfQfPGH6f/sfUFyyXCmkO6hsU=";
  };

  postPatch = ''
    echo "Compiling sass files"
    pushd liberaforms/static
    chronic sass sass:css --style=compressed --no-source-map
    popd
  '';

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
    flask-assets
    flask-babel
    flask-login
    flask-marshmallow
    flask-migrate
    flask-session2
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
    sqlalchemy
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

  nativeBuildInputs = [
    dart-sass
    moreutils # chronic
    postgresql
    libxml2
    libxslt
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -R . $out

    runHook postInstall
  '';

  doCheck = true;

  nativeCheckInputs = [
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

  # Run pytest on the installed version. A running postgres database server is needed.
  preCheck = ''
    export LANG=C.UTF-8
    export PGUSER=db_user
    export postgresqlEnableTCP=1
    pushd tests
    cp test.ini.example test.ini
  '';

  # avoid writing in the migration process
  postFixup = ''
    cp $out/assets/brand/logo-default.png $out/assets/brand/logo.png
    cp $out/assets/brand/favicon-default.ico $out/assets/brand/favicon.ico
    sed -i "/shutil.copyfile/d" $out/liberaforms/models/site.py
    sed -i "/brand_dir/d" $out/migrations/versions/6f0e2b9e9db3_.py
  '';

  meta = {
    description = "Ethical form software";
    homepage = "https://liberaforms.org";
    downloadPage = "https://codeberg.org/LiberaForms/server";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    # no mainProgram
    teams = with lib.teams; [ ngi ];
  };
})
