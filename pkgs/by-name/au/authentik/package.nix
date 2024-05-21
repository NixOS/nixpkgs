{ lib
, stdenvNoCC
, fetchFromGitHub
, buildNpmPackage
, buildGoModule
, runCommand
, openapi-generator-cli
, nodejs
, python3
, codespell
, makeWrapper }:

let
  version = "2024.2.2";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    hash = "sha256-2B1RgKY5tpDBdzguEyWqzg15w5x/dLS2ffjbnxbpINs=";
  };

  meta = with lib; {
    description = "The authentication glue you need";
    changelog = "https://github.com/goauthentik/authentik/releases/tag/version%2F${version}";
    homepage = "https://goauthentik.io/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jvanbruegge ];
  };

  website = buildNpmPackage {
    pname = "authentik-website";
    inherit version src meta;
    npmDepsHash = "sha256-paACBXG7hEQSLekxCvxNns2Tg9rN3DUgz6o3A/lAhA8=";

    NODE_ENV = "production";
    NODE_OPTIONS = "--openssl-legacy-provider";

    postPatch = ''
      cd website
    '';

    installPhase = ''
      cp -r help $out
    '';

    npmInstallFlags = [ "--include=dev" ];
    npmBuildScript = "build-docs-only";
  };

  clientapi = stdenvNoCC.mkDerivation {
    pname = "authentik-client-api";
    inherit version src meta;

    postPatch = ''
      rm Makefile

      substituteInPlace ./scripts/api-ts-config.yaml \
        --replace-fail '/local' "$(pwd)/"
    '';

    nativeBuildInputs = [ openapi-generator-cli ];
    buildPhase = ''
      runHook preBuild
      openapi-generator-cli generate -i ./schema.yml \
      -g typescript-fetch -o $out \
      -c ./scripts/api-ts-config.yaml \
        --additional-properties=npmVersion=${nodejs.pkgs.npm.version} \
        --git-repo-id authentik --git-user-id goauthentik
      runHook postBuild
    '';
  };

  webui = buildNpmPackage {
    pname = "authentik-webui";
    inherit version meta;

    src = runCommand "authentik-webui-source" {} ''
      mkdir -p $out/web/node_modules/@goauthentik/
      cp -r ${src}/web $out/
      ln -s ${src}/website $out/
      ln -s ${clientapi} $out/web/node_modules/@goauthentik/api
    '';
    npmDepsHash = "sha256-Xtzs91m+qu7jTwr0tMeS74gjlZs4vufGGlplPVf9yew=";

    postPatch = ''
      cd web
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist $out/dist
      cp -r authentik $out/authentik
      runHook postInstall
    '';

    NODE_ENV = "production";
    NODE_OPTIONS = "--openssl-legacy-provider";

    npmInstallFlags = [ "--include=dev" ];
  };

  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      django-tenants = prev.buildPythonPackage rec {
        pname = "django-tenants";
        version = "unstable-2024-01-11";
        src = fetchFromGitHub {
          owner = "rissson";
          repo = pname;
          rev = "a7f37c53f62f355a00142473ff1e3451bb794eca";
          hash = "sha256-YBT0kcCfETXZe0j7/f1YipNIuRrcppRVh1ecFS3cvNo=";
        };
        format = "setuptools";
        doCheck = false; # Tests require postgres

        propagatedBuildInputs = with prev; [
          django
          psycopg
          gunicorn
        ];
      };

      tenant-schemas-celery = prev.buildPythonPackage rec {
        pname = "tenant-schemas-celery";
        version = "2.2.0";
        src = fetchFromGitHub {
          owner = "maciej-gol";
          repo = pname;
          rev = version;
          hash = "sha256-OpIJobjWZE5GQGnHADioeoJo3A6DAKh0HdO10k4rsX4=";
        };
        format = "setuptools";
        doCheck = false;

        propagatedBuildInputs = with prev; [
          freezegun
          more-itertools
          psycopg2
        ];
      };

      authentik-django = prev.buildPythonPackage {
        pname = "authentik-django";
        inherit version src meta;
        pyproject = true;

        postPatch = ''
          rm lifecycle/system_migrations/tenant_files.py
          substituteInPlace authentik/root/settings.py \
            --replace-fail 'Path(__file__).absolute().parent.parent.parent' "\"$out\""
          substituteInPlace authentik/lib/default.yml \
            --replace-fail '/blueprints' "$out/blueprints" \
            --replace-fail './media' '/var/lib/authentik/media'
          substituteInPlace pyproject.toml \
            --replace-fail 'dumb-init = "*"' "" \
            --replace-fail 'djangorestframework-guardian' 'djangorestframework-guardian2' \
            --replace-fail 'version = "4.9.4"' 'version = "*"' \
            --replace-fail 'version = "<2"' 'version = "*"'
          substituteInPlace authentik/stages/email/utils.py \
            --replace-fail 'web/' '${webui}/'
        '';

        nativeBuildInputs = [ prev.poetry-core ];

        propagatedBuildInputs = with final; [
          argon2-cffi
          celery
          channels
          channels-redis
          colorama
          dacite
          daphne
          deepmerge
          defusedxml
          django
          django-filter
          django-guardian
          django-model-utils
          django-prometheus
          django-redis
          django-storages
          django-tenants
          djangorestframework
          djangorestframework-guardian2
          docker
          drf-spectacular
          duo-client
          facebook-sdk
          flower
          geoip2
          gunicorn
          httptools
          kubernetes
          ldap3
          lxml
          jsonpatch
          opencontainers
          packaging
          paramiko
          psycopg
          pycryptodome
          pydantic
          pydantic-scim
          pyjwt
          pyyaml
          requests-oauthlib
          sentry-sdk
          service-identity
          structlog
          swagger-spec-validator
          tenant-schemas-celery
          twilio
          twisted
          ua-parser
          urllib3
          uvicorn
          uvloop
          watchdog
          webauthn
          websockets
          wsproto
          xmlsec
          zxcvbn
        ] ++ [
          codespell
        ];

        postInstall = ''
          mkdir -p $out/web $out/website
          cp -r lifecycle manage.py $out/${prev.python.sitePackages}/
          cp -r blueprints $out/
          cp -r ${webui}/dist ${webui}/authentik $out/web/
          cp -r ${website} $out/website/help
          ln -s $out/${prev.python.sitePackages}/lifecycle $out/lifecycle
        '';
      };
    };
  };

  inherit (python.pkgs) authentik-django;

  proxy = buildGoModule {
    pname = "authentik-proxy";
    inherit version src meta;

    postPatch = ''
      substituteInPlace internal/gounicorn/gounicorn.go \
        --replace-fail './lifecycle' "${authentik-django}/lifecycle"
      substituteInPlace web/static.go \
        --replace-fail './web' "${authentik-django}/web"
      substituteInPlace internal/web/static.go \
        --replace-fail './web' "${authentik-django}/web"
    '';

    CGO_ENABLED = 0;

    vendorHash = "sha256-UIJBCTq7AJGUDIlZtJaWCovyxlMPzj2BCJQqthybEz4=";

    postInstall = ''
      mv $out/bin/server $out/bin/authentik
    '';

    subPackages = [ "cmd/server" ];
  };

in stdenvNoCC.mkDerivation {
  pname = "authentik";
  inherit src version;

  postPatch = ''
    rm Makefile
    patchShebangs lifecycle/ak

    # This causes issues in systemd services
    substituteInPlace lifecycle/ak \
      --replace-fail 'printf' '>&2 printf' \
      --replace-fail '> /dev/stderr' ""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r lifecycle/ak $out/bin/

    wrapProgram $out/bin/ak \
      --prefix PATH : ${lib.makeBinPath [ (python.withPackages (ps: [ps.authentik-django])) proxy ]} \
      --set TMPDIR /dev/shm \
      --set PYTHONDONTWRITEBYTECODE 1 \
      --set PYTHONUNBUFFERED 1
    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = meta // {
    mainProgram = "ak";
  };
}
