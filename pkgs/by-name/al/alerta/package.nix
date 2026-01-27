{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "alerta";
  version = "9.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alerta";
    repo = "alerta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QK06Iosr4LXYA/WEQWuizLYElWfESPr7pgjkSXOmX4s=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      bcrypt
      blinker
      cryptography
      flask
      flask-compress
      flask-cors
      mohawk
      psycopg2
      pyjwt
      pymongo
      pyparsing
      python-dateutil
      pytz
      pyyaml
      requests
      requests-hawk
      sentry-sdk
      strenum
      werkzeug
    ]
    ++ sentry-sdk.optional-dependencies.flask;

  optional-dependencies = {
    psycopg2 = with python3.pkgs; [ psycopg2 ];
    pymongo = with python3.pkgs; [ pymongo ];
  };

  # Tests require a mongodb instance
  doCheck = false;

  meta = {
    description = "Alerta Monitoring System command-line interface";
    homepage = "https://alerta.io";
    changelog = "https://github.com/alerta/alerta/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "alerta";
  };
})
