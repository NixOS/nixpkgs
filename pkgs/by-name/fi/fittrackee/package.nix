{
  fetchFromGitHub,
  fetchPypi,
  lib,
  postgresql,
  postgresqlTestHook,
  python3,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy_1_4;

      flask-sqlalchemy = super.flask-sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.5";

        src = fetchPypi {
          pname = "flask_sqlalchemy";
          inherit version;
          hash = "sha256-xXZeWMoUVAG1IQbA9GF4VpJDxdolVWviwjHsxghnxbE=";
        };
      });
    };
  };

in
python.pkgs.buildPythonApplication rec {
  pname = "fittrackee";
  version = "0.8.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    rev = "refs/tags/v${version}";
    hash = "sha256-IO6M+HXAR3Gn0/71KwkaQr6sB0eCQzmnqHYgO+mzIZM=";
  };

  build-system = [
    python.pkgs.poetry-core
  ];

  pythonRelaxDeps = [
    "authlib"
    "flask-limiter"
    "gunicorn"
    "pyjwt"
    "pyopenssl"
  ];

  dependencies =
    with python.pkgs;
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

  nativeCheckInputs = with python.pkgs; [
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

  preCheck = ''
    export TMP=$(mktemp -d)
  '';

  meta = {
    description = "Self-hosted outdoor activity tracker";
    homepage = "https://github.com/SamR1/FitTrackee";
    changelog = "https://github.com/SamR1/FitTrackee/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
