{
  lib,
  stdenvNoCC,
  callPackages,
  cacert,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
  runCommand,
  bash,
  chromedriver,
  openapi-generator-cli,
  nodejs,
  python312,
  makeWrapper,
}:

let
  version = "2025.4.1";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    hash = "sha256-idShMSYIrf3ViG9VFNGNu6TSjBz3Q+GJMMeCzcJwfG4=";
  };

  meta = {
    description = "Authentication glue you need";
    changelog = "https://github.com/goauthentik/authentik/releases/tag/version%2F${version}";
    homepage = "https://goauthentik.io/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    broken = stdenvNoCC.buildPlatform != stdenvNoCC.hostPlatform;
    maintainers = with lib.maintainers; [
      jvanbruegge
      risson
    ];
  };

  # prefetch-npm-deps does not save all dependencies even though the lockfile is fine
  website-deps = stdenvNoCC.mkDerivation {
    pname = "authentik-website-deps";
    inherit src version meta;

    sourceRoot = "${src.name}/website";

    outputHash = "sha256-AnQpjCoCTzm28Wl/t3YHx0Kl0CuMHL2OgRjRB1Trrsw=";
    outputHashMode = "recursive";

    nativeBuildInputs = [
      nodejs
      cacert
    ];

    buildPhase = ''
      npm ci --cache ./cache
      rm -r ./cache node_modules/.package-lock.json
    '';

    installPhase = ''
      mv node_modules $out
    '';

    dontPatchShebangs = true;
  };

  website = stdenvNoCC.mkDerivation {
    pname = "authentik-website";
    inherit src version meta;

    nativeBuildInputs = [ nodejs ];

    postPatch = ''
      substituteInPlace package.json --replace-fail 'cross-env ' ""
    '';

    sourceRoot = "${src.name}/website";

    buildPhase = ''
      runHook preBuild

      cp -r ${website-deps} node_modules
      chmod -R +w node_modules
      pushd node_modules/.bin
      patchShebangs $(readlink docusaurus)
      popd
      cat node_modules/.bin/docusaurus
      npm run build-bundled

      runHook postBuild
    '';

    installPhase = ''
      mkdir $out
      cp -r build $out/help
    '';
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
        --additional-properties=npmVersion="$(${lib.getExe' nodejs "npm"} --version)" \
        --git-repo-id authentik --git-user-id goauthentik
      runHook postBuild
    '';
  };

  webui = buildNpmPackage {
    pname = "authentik-webui";
    inherit version meta;

    src = runCommand "authentik-webui-source" { } ''
      mkdir -p $out/web/node_modules/@goauthentik/
      cp -r ${src}/web $out/
      ln -s ${src}/package.json $out/
      ln -s ${src}/website $out/
      ln -s ${clientapi} $out/web/node_modules/@goauthentik/api
    '';
    npmDepsHash = "sha256-i95sH+KUgAQ76cv1+7AE/UA6jsReQMttDGWClNE2Ol4=";

    postPatch = ''
      cd web
    '';

    CHROMEDRIVER_FILEPATH = lib.getExe chromedriver;

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist $out/dist
      cp -r authentik $out/authentik
      runHook postInstall
    '';

    NODE_ENV = "production";
    NODE_OPTIONS = "--openssl-legacy-provider";

    npmInstallFlags = [
      "--include=dev"
      "--ignore-scripts"
    ];
  };

  python = python312.override {
    self = python;
    packageOverrides = final: prev: {
      # https://github.com/goauthentik/authentik/pull/14709
      django = final.django_5_1;

      # Running authentik currently requires a custom version.
      # Look in `pyproject.toml` for changes to the rev in the `[tool.uv.sources]` section.
      # See https://github.com/goauthentik/authentik/pull/14057 for latest version bump.
      djangorestframework = prev.buildPythonPackage {
        pname = "djangorestframework";
        version = "3.16.0";
        format = "setuptools";

        src = fetchFromGitHub {
          owner = "authentik-community";
          repo = "django-rest-framework";
          rev = "896722bab969fabc74a08b827da59409cf9f1a4e";
          hash = "sha256-YrEDEU3qtw/iyQM3CoB8wYx57zuPNXiJx6ZjrIwnCNU=";
        };

        propagatedBuildInputs = with final; [
          django
          pytz
        ];

        nativeCheckInputs = with final; [
          pytest-django
          pytest7CheckHook

          # optional tests
          coreapi
          django-guardian
          inflection
          pyyaml
          uritemplate
        ];

        disabledTests = [
          "test_ignore_validation_for_unchanged_fields"
          "test_invalid_inputs"
          "test_shell_code_example_rendering"
          "test_unique_together_condition"
          "test_unique_together_with_source"
        ];

        pythonImportsCheck = [ "rest_framework" ];
      };

      authentik-django = prev.buildPythonPackage {
        pname = "authentik-django";
        inherit version src meta;
        pyproject = true;

        postPatch = ''
          rm lifecycle/system_migrations/tenant_files.py
          substituteInPlace authentik/root/settings.py \
            --replace-fail 'Path(__file__).absolute().parent.parent.parent' "Path(\"$out\")"
          substituteInPlace authentik/lib/default.yml \
            --replace-fail '/blueprints' "$out/blueprints" \
            --replace-fail './media' '/var/lib/authentik/media'
          substituteInPlace pyproject.toml \
            --replace-fail '"dumb-init",' "" \
            --replace-fail 'djangorestframework-guardian' 'djangorestframework-guardian2'
          substituteInPlace authentik/stages/email/utils.py \
            --replace-fail 'web/' '${webui}/'
        '';

        nativeBuildInputs = [
          prev.hatchling
          prev.pythonRelaxDepsHook
        ];

        pythonRelaxDeps = [
          "xmlsec"
        ];

        propagatedBuildInputs =
          with final;
          [
            argon2-cffi
            celery
            channels
            channels-redis
            cryptography
            dacite
            deepmerge
            defusedxml
            django
            django-countries
            django-cte
            django-filter
            django-guardian
            django-model-utils
            django-pglock
            django-prometheus
            django-redis
            django-storages
            django-tenants
            djangorestframework
            djangorestframework-guardian2
            docker
            drf-orjson-renderer
            drf-spectacular
            duo-client
            fido2
            flower
            geoip2
            geopy
            google-api-python-client
            gunicorn
            gssapi
            jsonpatch
            jwcrypto
            kubernetes
            ldap3
            lxml
            msgraph-sdk
            opencontainers
            packaging
            paramiko
            psycopg
            pydantic
            pydantic-scim
            pyjwt
            pyrad
            python-kadmin-rs
            pyyaml
            requests-oauthlib
            scim2-filter-parser
            sentry-sdk
            service-identity
            setproctitle
            structlog
            swagger-spec-validator
            tenant-schemas-celery
            twilio
            ua-parser
            unidecode
            urllib3
            uvicorn
            watchdog
            webauthn
            wsproto
            xmlsec
            zxcvbn
          ]
          ++ django-storages.optional-dependencies.s3
          ++ opencontainers.optional-dependencies.reggie
          ++ psycopg.optional-dependencies.c
          ++ psycopg.optional-dependencies.pool
          ++ uvicorn.optional-dependencies.standard;

        postInstall = ''
          mkdir -p $out/web $out/website
          cp -r lifecycle manage.py $out/${prev.python.sitePackages}/
          cp -r blueprints $out/
          cp -r ${webui}/dist ${webui}/authentik $out/web/
          cp -r ${website} $out/website/help
          ln -s $out/${prev.python.sitePackages}/authentik $out/authentik
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

    env.CGO_ENABLED = 0;

    vendorHash = "sha256-cEB22KFDONcJBq/FvLpYKN7Zd06mh8SACvCSuj5i4fI=";

    postInstall = ''
      mv $out/bin/server $out/bin/authentik
    '';

    subPackages = [ "cmd/server" ];
  };

in
stdenvNoCC.mkDerivation {
  pname = "authentik";
  inherit src version;

  buildInputs = [ bash ];

  postPatch = ''
    rm Makefile
    patchShebangs lifecycle/ak

    # This causes issues in systemd services
    substituteInPlace lifecycle/ak \
      --replace-fail 'printf' '>&2 printf' \
      --replace-fail '>/dev/stderr' ""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r lifecycle/ak $out/bin/

    wrapProgram $out/bin/ak \
      --prefix PATH : ${
        lib.makeBinPath [
          (python.withPackages (ps: [ ps.authentik-django ]))
          proxy
        ]
      } \
      --set TMPDIR /dev/shm \
      --set PYTHONDONTWRITEBYTECODE 1 \
      --set PYTHONUNBUFFERED 1
    runHook postInstall
  '';

  passthru.outposts = callPackages ./outposts.nix { };

  nativeBuildInputs = [ makeWrapper ];

  meta = meta // {
    mainProgram = "ak";
  };
}
