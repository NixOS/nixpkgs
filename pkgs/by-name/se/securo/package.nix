{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  buildNpmPackage,
  nixosTests,
  nix-update-script,
}:

let
  frontend =
    finalAttrs:
    buildNpmPackage {
      pname = "securo-frontend";
      inherit (finalAttrs) src version;
      npmDepsHash = "sha256-E3vhRzNfu7Wpf9e2g180OroC9pzHS2dBk+Ugb1jftyo=";

      sourceRoot = "source/frontend";

      env.VITE_APP_VERSION = finalAttrs.version;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/securo-ui
        cp -r dist/* $out/share/securo-ui/
        runHook postInstall
      '';

      meta = {
        description = "Web frontend for the Securo personal finance manager";
        homepage = "https://github.com/securo-finance/securo";
        license = lib.licenses.agpl3Only;
        maintainers = with lib.maintainers; [ pjrm ];
      };
    };

  # TODO: drop these overrides once fastapi-users and
  # fastapi-users-db-sqlalchemy land in nixpkgs.
  # https://github.com/NixOS/nixpkgs/pull/487106
  py = python3.override {
    packageOverrides = self: super: {
      fastapi-users = self.buildPythonPackage rec {
        pname = "fastapi-users";
        version = "15.0.5";
        pyproject = true;

        src = fetchPypi {
          pname = "fastapi_users";
          inherit version;
          hash = "sha256-CX9pcBiU5lDDRt+Jsc2woJzxOSNPTLmo7OJ1r06Y4gI=";
        };

        build-system = with self; [
          hatchling
          hatch-regex-commit
        ];

        dependencies = with self; [
          email-validator
          fastapi
          makefun
          pwdlib
          pyjwt
          python-multipart
        ];

        pythonRelaxDeps = [ "pwdlib" ];

        pythonImportsCheck = [ "fastapi_users" ];
      };

      fastapi-users-db-sqlalchemy = self.buildPythonPackage rec {
        pname = "fastapi-users-db-sqlalchemy";
        version = "7.0.0";
        pyproject = true;

        src = fetchPypi {
          pname = "fastapi_users_db_sqlalchemy";
          inherit version;
          hash = "sha256-aCPu7fipL4GSdqKyIQ7x3P1x/otuN/e02o0cYOPf1ZU=";
        };

        build-system = with self; [
          hatchling
          hatch-regex-commit
        ];

        dependencies = with self; [
          fastapi-users
          sqlalchemy
        ];

        pythonImportsCheck = [ "fastapi_users_db_sqlalchemy" ];
      };
    };
  };
in
py.pkgs.buildPythonPackage (finalAttrs: {
  pname = "securo-backend";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "securo-finance";
    repo = "securo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7AEt6BPol9YS0myHRR3P4eNf56t2QOxJ1SgD3QajB90=";
  };

  sourceRoot = "source/backend";
  pyproject = true;

  __structuredAttrs = true;

  build-system = with py.pkgs; [
    setuptools
  ];

  dependencies =
    with py.pkgs;
    [
      aiofiles
      alembic
      asyncpg
      celery
      cryptography
      fastapi
      fastapi-users
      fastapi-users-db-sqlalchemy
      fastembed
      httpx
      ofxparse
      passlib
      pgvector
      pydantic
      pydantic-settings
      pyotp
      pypdf
      python-jose
      python-multipart
      pyzipper
      redis
      reportlab
      sqlalchemy
      tzlocal
      uvicorn
      webauthn
      yfinance
    ]
    ++ celery.optional-dependencies.redis
    ++ passlib.optional-dependencies.bcrypt
    ++ python-jose.optional-dependencies.cryptography
    ++ redis.optional-dependencies.hiredis
    ++ uvicorn.optional-dependencies.standard;

  pythonRelaxDeps = [ "cryptography" ];

  postInstall = ''
    cp -r mcp_server $out/${py.sitePackages}/mcp_server

    mkdir -p $out/share/securo
    cp alembic.ini $out/share/securo/
    cp -r alembic $out/share/securo/
  '';

  nativeCheckInputs = with py.pkgs; [
    aiosqlite
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "app.main"
    "mcp_server.main"
  ];

  passthru = {
    frontend = frontend finalAttrs;
    tests = {
      inherit (nixosTests) securo;
    };
    updateScript = nix-update-script { extraArgs = [ "--subpackage=frontend" ]; };
  };

  meta = {
    description = "Self-hosted personal finance manager";
    homepage = "https://github.com/securo-finance/securo";
    changelog = "https://github.com/securo-finance/securo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pjrm ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
