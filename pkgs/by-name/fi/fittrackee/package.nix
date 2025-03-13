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
  version = "0.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    tag = "v${version}";
    hash = "sha256-O5dtices32EV/G9cefhewvr+OGnvq598YmwtwWaI3FI=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  pythonRelaxDeps = [
    "authlib"
    "flask-limiter"
    "flask-migrate"
    "nh3"
    "pyopenssl"
    "pytz"
    "sqlalchemy"
  ];

  dependencies =
    with python3Packages;
    [
      authlib
      babel
      click
      dramatiq
      flask
      flask-bcrypt
      flask-dramatiq
      flask-limiter
      flask-migrate
      flask-sqlalchemy
      gpxpy
      gunicorn
      humanize
      jsonschema
      nh3
      psycopg2-binary
      pyjwt
      pyopenssl
      pytz
      shortuuid
      sqlalchemy
      staticmap
      ua-parser
    ]
    ++ dramatiq.optional-dependencies.redis
    ++ flask-limiter.optional-dependencies.redis;

  pythonImportsCheck = [ "fittrackee" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    freezegun
    postgresqlTestHook
    postgresql
    time-machine
  ];

  pytestFlagsArray = [
    "fittrackee"
  ];

  postgresqlTestSetupPost = ''
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
    maintainers = with lib.maintainers; [ traxys ];
  };
}
