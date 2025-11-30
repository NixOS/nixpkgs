{
  lib,
  stdenvNoCC,
  callPackages,
  cacert,
  fetchFromGitHub,
  buildGoModule,
  bash,
  chromedriver,
  nodejs_24,
  python312,
  makeWrapper,
}:

let
  nodejs = nodejs_24;

  version = "2025.10.1";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    tag = "version/${version}";
    hash = "sha256-HowB6DTGCqz770fKYbnE+rQ11XRV0WSNkLD+HSWZwz8=";
  };

  meta = {
    description = "Authentication glue you need";
    changelog = "https://github.com/goauthentik/authentik/releases/tag/version%2F${version}";
    homepage = "https://goauthentik.io/";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
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

    outputHash =
      {
        "aarch64-linux" = "sha256-aXXlzTsZp5mOrsxy9oHNzcc+1cFSnbC9RmtawBohmLI=";
        "x86_64-linux" = "sha256-Hi0HXzwTLuer0v4IKF3aim0tVe7AVLi67DiMimrIq5s=";
      }
      .${stdenvNoCC.hostPlatform.system} or (throw "authentik-website-deps: unsupported host platform");

    outputHashMode = "recursive";

    nativeBuildInputs = [
      nodejs
      cacert
    ];

    buildPhase = ''
      npm ci --cache ./cache

      rm -r ./cache node_modules/.package-lock.json
    '';

    # dependencies of workspace projects are installed into separate node_modules folders with
    # symlinks between them, so we have to copy all of them
    installPhase = ''
      mkdir $out
      echo "Copying node_modules folders:"
      find -type d -name node_modules -prune -print -exec mkdir -p $out/{} \; -exec cp -rT {} $out/{} \;
    '';

    dontCheckForBrokenSymlinks = true;
    dontPatchShebangs = true;
  };

  website = stdenvNoCC.mkDerivation {
    pname = "authentik-website";
    inherit src version meta;

    nativeBuildInputs = [ nodejs ];

    sourceRoot = "${src.name}/website";

    buildPhase = ''
      runHook preBuild

      buildRoot=$PWD
      pushd ${website-deps}
      find -type d -name node_modules -prune -print -exec cp -rT {} $buildRoot/{} \;
      popd

      chmod -R +w node_modules

      pushd node_modules/.bin
      patchShebangs $(readlink docusaurus) $(readlink run-s)
      popd
      npm run build:api

      runHook postBuild
    '';

    installPhase = ''
      mkdir $out
      cp -r api/build $out/help
    '';
  };

  # prefetch-npm-deps does not save all dependencies even though the lockfile is fine
  webui-deps = stdenvNoCC.mkDerivation {
    pname = "authentik-webui-deps";
    inherit src version meta;

    sourceRoot = "${src.name}/web";

    outputHash =
      {
        "aarch64-linux" = "sha256-t/jyzG3ibTW3fu8Gl1tWkSjMG6Lek/7JDccDrZX6sD0=";
        "x86_64-linux" = "sha256-8I1YAKvgWjM3p9O1mCetZvhZelrfB31w0ZwkZBUEoh4=";
      }
      .${stdenvNoCC.hostPlatform.system} or (throw "authentik-webui-deps: unsupported host platform");
    outputHashMode = "recursive";

    nativeBuildInputs = [
      nodejs
      cacert
    ];

    buildPhase = ''
      npm ci --cache ./cache --ignore-scripts

      rm -r ./cache node_modules/.package-lock.json
    '';

    # dependencies of workspace projects are installed into separate node_modules folders with
    # symlinks between them, so we have to copy all of them
    installPhase = ''
      mkdir $out
      echo "Copying node_modules folders:"
      find -type d -name node_modules -prune -print -exec mkdir -p $out/{} \; -exec cp -rT {} $out/{} \;
    '';

    dontCheckForBrokenSymlinks = true;
    dontPatchShebangs = true;
  };

  webui = stdenvNoCC.mkDerivation {
    pname = "authentik-webui";
    inherit src version meta;

    sourceRoot = "${src.name}/web";

    nativeBuildInputs = [
      nodejs
    ];

    postPatch = ''
      substituteInPlace packages/core/version/node.js \
        --replace-fail 'import PackageJSON from "../../../../package.json" with { type: "json" };' "" \
        --replace-fail '(PackageJSON.version);' '"${version}";'
    '';

    buildPhase = ''
      runHook preBuild

      buildRoot=$PWD
      pushd ${webui-deps}
      find -type d -name node_modules -prune -print -exec cp -rT {} $buildRoot/{} \;
      popd

      pushd node_modules/.bin
      patchShebangs $(readlink rollup)
      patchShebangs $(readlink wireit)
      patchShebangs $(readlink lit-localize)
      popd

      npm run build

      runHook postBuild
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
      # https://github.com/goauthentik/authentik/pull/16324
      django = final.django_5_2;

      django-channels-postgres = final.buildPythonPackage {
        pname = "django-channels-postgres";
        inherit version src meta;
        pyproject = true;

        sourceRoot = "${src.name}/packages/django-channels-postgres";

        build-system = with final; [ hatchling ];

        propagatedBuildInputs =
          with final;
          [
            channels
            django
            django-pgtrigger
            msgpack
            psycopg
            structlog
          ]
          ++ psycopg.optional-dependencies.pool;
      };

      django-dramatiq-postgres = final.buildPythonPackage {
        pname = "django-dramatiq-postgres";
        inherit version src meta;
        pyproject = true;

        sourceRoot = "${src.name}/packages/django-dramatiq-postgres";

        build-system = with final; [ hatchling ];

        propagatedBuildInputs =
          with final;
          [
            cron-converter
            django
            django-pglock
            django-pgtrigger
            dramatiq
            structlog
            tenacity
          ]
          ++ dramatiq.optional-dependencies.watch;
      };

      django-postgres-cache = final.buildPythonPackage {
        pname = "django-postgres-cache";
        inherit version src meta;
        pyproject = true;

        sourceRoot = "${src.name}/packages/django-postgres-cache";

        build-system = with final; [ hatchling ];

        propagatedBuildInputs = with final; [
          django
          django-postgres-extra
        ];
      };

      # Running authentik currently requires a custom version.
      # Look in `pyproject.toml` for changes to the rev in the `[tool.uv.sources]` section.
      # See https://github.com/goauthentik/authentik/pull/14057 for latest version bump.
      djangorestframework = final.buildPythonPackage {
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

      # authentik is currently not compatible with v1.18 and fails with the following error:
      # > AttributeError: 'Namespace' object has no attribute 'worker_fork_timeout'. Did you mean: 'worker_shutdown_timeout'?
      dramatiq = prev.dramatiq.overrideAttrs (_: rec {
        version = "1.17.1";

        src = fetchFromGitHub {
          owner = "Bogdanp";
          repo = "dramatiq";
          tag = "v${version}";
          hash = "sha256-NeUGhG+H6r+JGd2qnJxRUbQ61G7n+3tsuDugTin3iJ4=";
        };
      });

      authentik-django = final.buildPythonPackage {
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
          substituteInPlace authentik/stages/email/utils.py \
            --replace-fail 'web/' '${webui}/'
        '';

        nativeBuildInputs = [
          prev.hatchling
          prev.pythonRelaxDepsHook
        ];

        pythonRemoveDeps = [ "dumb-init" ];

        pythonRelaxDeps = true;

        propagatedBuildInputs =
          with final;
          [
            argon2-cffi
            channels
            cryptography
            dacite
            deepmerge
            defusedxml
            django
            django-channels-postgres
            django-countries
            django-cte
            django-dramatiq-postgres
            django-filter
            django-guardian
            django-model-utils
            django-pglock
            django-pgtrigger
            django-postgres-cache
            django-postgres-extra
            django-prometheus
            django-storages
            django-tenants
            djangoql
            djangorestframework
            djangorestframework-guardian
            docker
            drf-orjson-renderer
            drf-spectacular
            duo-client
            fido2
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

    vendorHash = "sha256-m2shrCwoVdbtr8B83ZcAyG+J6dEys2xdjtlfFFF4CDo=";

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

  passthru = {
    inherit proxy;
    outposts = callPackages ./outposts.nix {
      inherit (proxy) vendorHash;
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  meta = meta // {
    mainProgram = "ak";
  };
}
