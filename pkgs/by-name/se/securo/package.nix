{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
  buildNpmPackage,
  nixosTests,
  ...
}:

let
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

  src = fetchFromGitHub {
    owner = "securo-finance";
    repo = "securo";
    rev = "v${version}";
    inherit (sources) hash;
  };

  frontend = buildNpmPackage {
    pname = "securo-frontend";
    inherit src version;
    inherit (sources) npmDepsHash;

    sourceRoot = "source/frontend";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/securo-ui
      cp -r dist $out/share/securo-ui/
      runHook postInstall
    '';
  };

  py = python3.override {
    packageOverrides = self: super: {
      # Needed until this PR this merged https://github.com/NixOS/nixpkgs/pull/487106
      fastapi-users =
        super.fastapi-users or (self.buildPythonPackage rec {
          pname = "fastapi-users";
          version = "15.0.5";
          format = "pyproject";
          src = fetchurl {
            url = "https://files.pythonhosted.org/packages/source/f/fastapi-users/fastapi_users-${version}.tar.gz";
            hash = "sha256-CX9pcBiU5lDDRt+Jsc2woJzxOSNPTLmo7OJ1r06Y4gI=";
          };
          dontCheckRuntimeDeps = true;
          nativeBuildInputs = with self; [
            hatchling
            hatch-regex-commit
          ];
          propagatedBuildInputs = with self; [
            email-validator
            fastapi
            makefun
            pwdlib
            pyjwt
            python-multipart
          ];
          pythonImportsCheck = [ "fastapi_users" ];
        });

      # Needed until this PR this merged https://github.com/NixOS/nixpkgs/pull/487106
      fastapi-users-db-sqlalchemy =
        super.fastapi-users-db-sqlalchemy or (self.buildPythonPackage rec {
          pname = "fastapi-users-db-sqlalchemy";
          version = "7.0.0";
          format = "pyproject";
          src = fetchurl {
            url = "https://files.pythonhosted.org/packages/source/f/fastapi-users-db-sqlalchemy/fastapi_users_db_sqlalchemy-${version}.tar.gz";
            hash = "sha256-aCPu7fipL4GSdqKyIQ7x3P1x/otuN/e02o0cYOPf1ZU=";
          };
          nativeBuildInputs = with self; [
            hatchling
            hatch-regex-commit
          ];
          propagatedBuildInputs = with self; [
            fastapi-users
            sqlalchemy
          ];
          pythonImportsCheck = [ "fastapi_users_db_sqlalchemy" ];
        });
    };
  };
in
py.pkgs.buildPythonPackage {
  pname = "securo";
  inherit src version;

  sourceRoot = "source/backend";
  pyproject = true;

  __structuredAttrs = true;

  dontCheckRuntimeDeps = true;

  nativeBuildInputs = with py.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with py.pkgs; [
    fastapi
    uvicorn
    sqlalchemy
    alembic
    asyncpg
    pydantic
    pydantic-settings
    python-jose
    cryptography
    passlib
    fastapi-users
    fastapi-users-db-sqlalchemy
    httpx
    python-multipart
    ofxparse
    celery
    aiofiles
    redis
    pyotp
    yfinance
    pgvector
    pypdf
    fastembed
    webauthn
  ];

  postInstall = ''
    cp -r mcp_server $out/${python3.sitePackages}/mcp_server
    mkdir -p $out/share/securo
    cp alembic.ini $out/share/securo/
    cp -r alembic $out/share/securo/
    cp -r ${frontend}/share/securo-ui $out/share/
  '';

  passthru = {
    tests = {
      inherit (nixosTests) securo;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Securo - self-hosted personal finance manager";
    homepage = "https://github.com/securo-finance/securo";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ pjrm ];
    platforms = platforms.linux;
  };
}
