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
  version = "2023.10.7";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    hash = "sha256-+1IdXRt28UZ2KTa0zsmjneNUOcutP99UUwqcYyVyqTI=";
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
    npmDepsHash = "sha256-4dgFxEvMnp+35nSQNsEchtN1qoS5X2KzEbLPvMnyR+k=";

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
    npmDepsHash = "sha256-5aCKlArtoEijGqeYiY3zoV0Qo7/Xt5hSXbmy2uYZpok=";

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
      authentik-django = prev.buildPythonPackage {
        pname = "authentik-django";
        inherit version src meta;
        pyproject = true;

        postPatch = ''
          substituteInPlace authentik/root/settings.py \
            --replace-fail 'Path(__file__).absolute().parent.parent.parent' "\"$out\""
          substituteInPlace authentik/lib/default.yml \
            --replace-fail '/blueprints' "$out/blueprints"
          substituteInPlace pyproject.toml \
            --replace-fail 'dumb-init = "*"' "" \
            --replace-fail 'djangorestframework-guardian' 'djangorestframework-guardian2'
        '';

        nativeBuildInputs = [ prev.poetry-core ];

        propagatedBuildInputs = with prev; [
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
          structlog
          swagger-spec-validator
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
          jsonpatch
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

    vendorHash = "sha256-74rSuZrO5c7mjhHh0iQlJEkOslsFrcDb1aRXXC4RsUM=";

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
