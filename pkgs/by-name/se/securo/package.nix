{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
  buildNpmPackage,
  nixosTests,
}:

let
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

  src = fetchFromGitHub {
    owner = "securo-finance";
    repo = "securo";
    tag = "v${version}";
    inherit (sources) hash;
  };

  frontend = buildNpmPackage {
    pname = "securo-frontend";
    inherit src version;
    inherit (sources) npmDepsHash;

    sourceRoot = "source/frontend";

    env.VITE_APP_VERSION = version;

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

        src = fetchurl {
          url = "https://files.pythonhosted.org/packages/source/f/fastapi-users/fastapi_users-${version}.tar.gz";
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

        pythonImportsCheck = [ "fastapi_users" ];
      };

      fastapi-users-db-sqlalchemy = self.buildPythonPackage rec {
        pname = "fastapi-users-db-sqlalchemy";
        version = "7.0.0";
        pyproject = true;

        src = fetchurl {
          url = "https://files.pythonhosted.org/packages/source/f/fastapi-users-db-sqlalchemy/fastapi_users_db_sqlalchemy-${version}.tar.gz";
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
py.pkgs.buildPythonPackage {
  pname = "securo-backend";
  inherit src version;

  sourceRoot = "source/backend";
  pyproject = true;

  __structuredAttrs = true;

  build-system = with py.pkgs; [
    setuptools
  ];

  dependencies = with py.pkgs; [
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
    redis
    sqlalchemy
    uvicorn
    webauthn
    yfinance
  ];

  # Upstream pins exact versions of most dependencies.
  pythonRelaxDeps = true;

  postInstall = ''
    cp -r mcp_server $out/${py.sitePackages}/mcp_server

    mkdir -p $out/share/securo
    cp alembic.ini $out/share/securo/
    cp -r alembic $out/share/securo/
  '';

  pythonImportsCheck = [
    "app"
    "mcp_server"
  ];

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) securo;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted personal finance manager";
    homepage = "https://github.com/securo-finance/securo";
    changelog = "https://github.com/securo-finance/securo/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pjrm ];
    platforms = lib.platforms.linux;
  };
}
