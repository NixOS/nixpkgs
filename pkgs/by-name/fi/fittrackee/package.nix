{
  fetchFromGitHub,
  lib,
  stdenv,
  postgresql,
  postgresqlTestHook,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "fittrackee";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    tag = "v${version}";
    hash = "sha256-wXj/bygm+Pa6b0sM+UYHPSpH/mlfozvPGu5pO6DutvA=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  pythonRelaxDeps = [
    "authlib"
    "click"
    "fitdecode"
    "flask"
    "flask-limiter"
    "flask-migrate"
    "humanize"
    "jsonschema"
    "lxml"
    "mistune"
    "nh3"
    "numpy"
    "pandas"
    "pyopenssl"
    "pytz"
    "sqlalchemy"
    "xmltodict"
  ];

  dependencies =
    with python3Packages;
    [
      authlib
      babel
      click
      dramatiq
      dramatiq-abort
      feedgenerator
      fitdecode
      flask
      flask-babel
      flask-bcrypt
      flask-dramatiq
      flask-limiter
      flask-migrate
      flask-sqlalchemy
      geoalchemy2
      geopandas
      gpxpy
      gunicorn
      humanize
      jsonschema
      nh3
      mistune
      numpy
      pandas
      psycopg2-binary
      pyjwt
      pyopenssl
      pytz
      shortuuid
      sqlalchemy
      staticmap3
      ua-parser
      xmltodict
    ]
    ++ dramatiq.optional-dependencies.redis
    ++ flask-limiter.optional-dependencies.redis;

  pythonImportsCheck = [ "fittrackee" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    freezegun
    postgresqlTestHook
    (postgresql.withPackages (ps: with ps; [ postgis ]))
    time-machine
  ];

  enabledTestPaths = [
    "fittrackee"
  ];

  postgresqlTestSetupPost = ''
    echo "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" | PGUSER=postgres psql test_db
    export DATABASE_TEST_URL=postgresql://$PGUSER/$PGDATABASE?host=$PGHOST
  '';

  doCheck = !stdenv.hostPlatform.isDarwin; # tests are a bit flaky on darwin

  preCheck = ''
    export TMP=$TMPDIR
    export UI_URL=http://0.0.0.0:5000
  '';

  meta = {
    description = "Self-hosted outdoor activity tracker";
    homepage = "https://github.com/SamR1/FitTrackee";
    changelog = "https://github.com/SamR1/FitTrackee/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      tebriel
      traxys
    ];
  };
}
