{
  lib,
  python3,
  fetchPypi,
  fetchFromGitHub,
  git,
  postgresql,
  postgresqlTestHook,
  valkey,
  redisTestHook,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = final: prev: {
      # sqlalchemy 2.0 is not supported
      sqlalchemy = prev.sqlalchemy_1_4;

      # checkInputs do not work wiht sqlalchemy < 2.0
      factory-boy = prev.factory-boy.overridePythonAttrs (
        lib.const {
          doCheck = false;
        }
      );

      # https://github.com/irrdnet/irrd/blob/22fe77e46ef1b4e43e346257795e171e7ee70d44/pyproject.toml#L30
      beautifultable = prev.beautifultable.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-1E2VUbvte/qIZ1Mk+E77mqhXOE1E6fsh61MPCgutuBU=";
        };
        doCheck = false;
      });

      # https://github.com/irrdnet/irrd/blob/0fd95020279060f2bc2816c0533c825e40f4c73c/pyproject.toml#L58C1-L59C1
      limits = prev.limits.overridePythonAttrs (oldAttrs: rec {
        version = "5.6.0";
        src = fetchFromGitHub {
          owner = "alisaifee";
          repo = "limits";
          tag = version;
          hash = "sha256-kghfF2ihEvyMPEGO1m9BquCdeBsYRoPyIljdLL1hToQ=";
        };
        doCheck = false;
      });

    };
  };
in

py.pkgs.buildPythonPackage (finalAttrs: {
  pname = "irrd";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "irrdnet";
    repo = "irrd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6z94Ha2QQ0LE4o3hzsNl4y/nPv849cSP8on3UeegE4c=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  nativeCheckInputs = [
    git
    valkey
    redisTestHook
    postgresql
    postgresqlTestHook
  ]
  ++ (with py.pkgs; [
    pytest-asyncio_0
    pytest-freezegun
    pytestCheckHook
    smtpdfix
    httpx
  ]);

  dependencies =
    with py.pkgs;
    [
      python-gnupg
      passlib
      bcrypt
      ipy
      ordered-set
      beautifultable
      pyyaml
      datrie
      setproctitle
      python-daemon
      pid
      py.pkgs.redis
      hiredis
      coredis
      requests
      pytz
      ariadne
      uvicorn
      starlette
      psutil
      asgiref
      pydantic
      typing-extensions
      py-radix-sr
      psycopg2-binary
      sqlalchemy
      alembic
      ujson
      wheel
      websockets
      limits
      factory-boy
      webauthn
      wtforms
      imia
      starlette-wtf
      zxcvbn
      pyotp
      asgi-logger
      wtforms-bootstrap5
      email-validator
      jinja2
      joserfc
      time-machine
    ]
    ++ py.pkgs.uvicorn.optional-dependencies.standard;

  preCheck = ''
    export SMTPD_HOST=127.0.0.1
    export IRRD_DATABASE_URL="postgresql:///$PGDATABASE"
    export IRRD_REDIS_URL="redis://localhost/1"
  '';

  # required for test_object_writing_and_status_checking
  postgresqlTestSetupPost = ''
    echo "track_commit_timestamp=on" >> $PGDATA/postgresql.conf
    pg_ctl restart
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  disabledTests = [
    # Skip tests that require internet access
    "test_020_dash_o_noop"
    "test_050_non_json_response"
  ];

  disabledTestPaths = [
    # Doesn't work with later pytest releases
    "irrd/server/whois/tests/test_query_response.py"
  ];

  meta = {
    changelog = "https://irrd.readthedocs.io/en/${finalAttrs.src.tag}/releases/";
    description = "Internet Routing Registry database server, processing IRR objects in the RPSL format";
    license = lib.licenses.mit;
    homepage = "https://github.com/irrdnet/irrd";
    maintainers = with lib.maintainers; [ yureka-wdz ];
  };
})
