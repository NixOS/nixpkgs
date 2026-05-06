{
  fetchFromCodeberg,
  lib,
  stdenv,
  postgresql,
  postgresqlTestHook,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fittrackee";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "FitTrackee";
    repo = "FitTrackee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GHr2TivOJcC0ZigoVznyImZrFtHSaqdHxcw4Pc1kw40=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  pythonRelaxDeps = true;

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
      lxml
      mistune
      nh3
      numpy
      pandas
      psycopg2-binary
      pyjwt
      pyopenssl
      pyproj
      python-magic
      pytz
      shortuuid
      sqlalchemy
      staticmap3
      ua-parser
      xmltodict
    ]
    ++ dramatiq.optional-dependencies.redis
    ++ flask-limiter.optional-dependencies.redis
    ++ geoalchemy2.optional-dependencies.shapely
    ++ staticmap3.optional-dependencies.filecache;

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
    homepage = "https://docs.fittrackee.org/en/index.html";
    changelog = "https://codeberg.org/FitTrackee/FitTrackee/src/commit/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      tebriel
      traxys
    ];
  };
})
