{ lib
, python3
, fetchPypi
, fetchFromGitHub
, fetchpatch
, git
, postgresql
, postgresqlTestHook
, redis
}:

let
  py = python3.override {
    packageOverrides = final: prev: {
      # sqlalchemy 1.4.x or 2.x are not supported
      sqlalchemy = prev.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
      });
      alembic = prev.alembic.overridePythonAttrs (lib.const {
        doCheck = false;
      });
      factory-boy = prev.factory-boy.overridePythonAttrs (lib.const {
        doCheck = false;
      });
      beautifultable = prev.beautifultable.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.0";
        src = fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-1E2VUbvte/qIZ1Mk+E77mqhXOE1E6fsh61MPCgutuBU=";
        };
        doCheck = false;
      });
    };
  };
in

py.pkgs.buildPythonPackage rec {
  pname = "irrd";
  version = "4.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "irrdnet";
    repo = "irrd";
    rev = "v${version}";
    hash = "sha256-UIOKXU92JEOeVdpYLNmDBtLn0u3LMdKItcn9bFd9u8g=";
  };

  patches = [
    # starlette 0.37.2 reverted the behaviour change which this adjusted to
    (fetchpatch {
      url = "https://github.com/irrdnet/irrd/commit/43e26647e18f8ff3459bbf89ffbff329a0f1eed5.patch";
      revert = true;
      hash = "sha256-G216rHfWMZIl9GuXBz6mjHCIm3zrfDDLSmHQK/HkkzQ=";
    })
    # Backport build fix for webauthn 2.1
    (fetchpatch {
      url = "https://github.com/irrdnet/irrd/commit/20b771e1ee564f38e739fdb0a2a79c10319f638f.patch";
      hash = "sha256-PtNdhSoFPT1kt71kFsySp/VnUpUdO23Gu9FKknHLph8=";
      includes = ["irrd/webui/auth/endpoints_mfa.py"];
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail psycopg2-binary psycopg2
  '';
  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  nativeCheckInputs = [
    git
    redis
    postgresql
    postgresqlTestHook
  ] ++ (with py.pkgs; [
    pytest-asyncio
    pytest-freezegun
    pytestCheckHook
    smtpdfix
    httpx
  ]);

  propagatedBuildInputs = with py.pkgs; [
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
    psycopg2
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
  ] ++ py.pkgs.uvicorn.optional-dependencies.standard;

  preCheck = ''
    redis-server &
    REDIS_PID=$!

    while ! redis-cli --scan ; do
      echo waiting for redis
      sleep 1
    done

    export SMTPD_HOST=127.0.0.1
    export IRRD_DATABASE_URL="postgres:///$PGDATABASE"
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

  # skip tests that require internet access
  disabledTests = [
    "test_020_dash_o_noop"
    "test_050_non_json_response"
  ];

  meta = with lib; {
    changelog = "https://irrd.readthedocs.io/en/v${version}/releases/";
    description = "Internet Routing Registry database server, processing IRR objects in the RPSL format";
    license = licenses.mit;
    homepage = "https://github.com/irrdnet/irrd";
    maintainers = teams.wdz.members;
  };
}

