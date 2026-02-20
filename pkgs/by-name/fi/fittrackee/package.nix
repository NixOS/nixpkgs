{
  fetchFromGitHub,
  lib,
  stdenv,
  postgresql,
  postgresqlTestHook,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fittrackee";
  version = "0.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SamR1";
    repo = "FitTrackee";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A9gebHxNCpYUUIm7IjyySojIIyuTxfYCUeUufpUM1iA=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  # The upstream project changed the behavior of the CLI when --set-admin and --set-role are used together.
  # Previously, it would raise an error, but now it issues a deprecation warning.
  # This patch updates the test assertion to expect the new deprecation warning message.
  # See upstream commit 6eda1b6119b3e41bdf8896e74b4a07d3c9e97609.
  postPatch = ''
    substituteInPlace fittrackee/tests/users/test_users_commands.py \
      --replace '"--set-admin and --set-role can not be used together."' '"WARNING: --set-admin is deprecated. Please use --set-role option instead."'
  '';

  pythonRelaxDeps = [
    "authlib"
    "fitdecode"
    "flask"
    "flask-limiter"
    "flask-migrate"
    "nh3"
    "lxml"
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
      fitdecode
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
    postgresql
    time-machine
  ];

  enabledTestPaths = [
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
    changelog = "https://github.com/SamR1/FitTrackee/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      tebriel
      traxys
    ];
  };
})
