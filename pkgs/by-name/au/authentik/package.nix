{
  lib,
  stdenvNoCC,
  callPackages,
  cacert,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
  runCommand,
  chromedriver,
  openapi-generator-cli,
  nodejs,
  python312,
  makeWrapper,
}:

let
  version = "2024.12.1";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    hash = "sha256-CkUmsVKzAQ/VWIhtxWxlcGtrWVa8hxqsMqvfcsG5ktA=";
  };

  meta = with lib; {
    description = "Authentication glue you need";
    changelog = "https://github.com/goauthentik/authentik/releases/tag/version%2F${version}";
    homepage = "https://goauthentik.io/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      jvanbruegge
      risson
    ];
  };

  # prefetch-npm-deps does not save all dependencies even though the lockfile is fine
  website-deps = stdenvNoCC.mkDerivation {
    pname = "authentik-website-deps";
    inherit src version meta;

    sourceRoot = "source/website";

    outputHash = "sha256-SONw9v67uuVk8meRIuS1KaBGbej6Gbz6nZxPDnHfCwQ=";
    outputHashMode = "recursive";

    nativeBuildInputs = [
      nodejs
      cacert
    ];

    buildPhase = ''
      npm ci --cache ./cache
      rm -r ./cache
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

    sourceRoot = "source/website";

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
    npmDepsHash = "sha256-aRfpJWTp2WQB3E9aqzJn3BiPLwpCkdvMoyHexaKvz0U=";

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
      django-tenants = prev.django-tenants.overrideAttrs {
        version = "3.6.1-unstable-2024-01-11";
        src = fetchFromGitHub {
          owner = "rissson";
          repo = "django-tenants";
          rev = "a7f37c53f62f355a00142473ff1e3451bb794eca";
          hash = "sha256-YBT0kcCfETXZe0j7/f1YipNIuRrcppRVh1ecFS3cvNo=";
        };
      };
      # Use 3.14.0 until https://github.com/encode/django-rest-framework/issues/9358 is fixed.
      # Otherwise applying blueprints/default/default-brand.yaml fails with:
      #   authentik.flows.models.RelatedObjectDoesNotExist: FlowStageBinding has no target.
      djangorestframework = prev.buildPythonPackage rec {
        pname = "djangorestframework";
        version = "3.14.0";
        format = "setuptools";

        src = fetchFromGitHub {
          owner = "encode";
          repo = "django-rest-framework";
          rev = version;
          hash = "sha256-Fnj0n3NS3SetOlwSmGkLE979vNJnYE6i6xwVBslpNz4=";
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
          pyyaml
          uritemplate
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
            --replace-fail 'dumb-init = "*"' "" \
            --replace-fail 'djangorestframework-guardian' 'djangorestframework-guardian2'
          substituteInPlace authentik/stages/email/utils.py \
            --replace-fail 'web/' '${webui}/'
        '';

        nativeBuildInputs = [
          prev.poetry-core
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

    vendorHash = "sha256-FyRTPs2xfostV2x03IjrxEYBSrsZwnuPn+oHyQq1Kq0=";

    postInstall = ''
      mv $out/bin/server $out/bin/authentik
    '';

    subPackages = [ "cmd/server" ];
  };

in
stdenvNoCC.mkDerivation {
  pname = "authentik";
  inherit src version;

  postPatch = ''
    rm Makefile
    patchShebangs lifecycle/ak
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
