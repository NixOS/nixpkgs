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
  python3,
  makeWrapper,
  openapi-generator-cli,
  go,
  typescript,
  makeSetupHook,
  writeShellScript,
}:

let
  nodejs = nodejs_24;

  version = "2025.12.4";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    tag = "version/${version}";
    hash = "sha256-alTyrMBbjZbw4jhEna8saabf93sqSrZCu+Z5xH3pZ7M=";
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

  client-go = stdenvNoCC.mkDerivation {
    pname = "authentik-client-go";
    version = "3.${version}";
    inherit meta;

    src = fetchFromGitHub {
      owner = "goauthentik";
      repo = "client-go";
      tag = "v3.${version}";
      hash = "sha256-+/CfOE2HkBU+ZddvdXGenB/z8xNFk8cujpZpMXyh3cY=";
    };

    patches = [
      ./client-go-config.patch
    ];

    postPatch = ''
      substituteInPlace ./config.yaml \
        --replace-fail '/local' "$(pwd)"
    '';

    nativeBuildInputs = [
      openapi-generator-cli
      go
    ];

    buildPhase = ''
      runHook preBuild

      openapi-generator-cli generate \
        -i ${src}/schema.yml -o $out \
        -g go \
        -c ./config.yaml

      gofmt -w $out

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp go.mod go.sum $out

      cd $out
      rm -rf test
      rm -f .travis.yml git_push.sh

      runHook postInstall
    '';
  };

  client-ts = stdenvNoCC.mkDerivation {
    pname = "authentik-client-ts";
    inherit version src meta;

    postPatch = ''
      substituteInPlace ./scripts/api/ts-config.yaml \
        --replace-fail '/local' "$(pwd)"
    '';

    nativeBuildInputs = [
      nodejs
      openapi-generator-cli
      typescript
    ];

    buildPhase = ''
      runHook preBuild

      openapi-generator-cli generate \
        -i ./schema.yml -o $out \
        -g typescript-fetch \
        -c ./scripts/api/ts-config.yaml \
        --additional-properties=npmVersion=${version} \
        --git-repo-id authentik --git-user-id goauthentik

      cd $out
      npm run build

      runHook postBuild
    '';
  };

  # prefetch-npm-deps does not save all dependencies even though the lockfile is fine
  website-deps = stdenvNoCC.mkDerivation {
    pname = "authentik-website-deps";
    inherit src version meta;

    sourceRoot = "${src.name}/website";

    outputHash =
      {
        "aarch64-linux" = "sha256-GL5FPIBnoEXYtw8DPJpRPe3tT3qioN4AdoeOmCoiYsM=";
        "x86_64-linux" = "sha256-AnceTipq6uUvTbOAZanVshAbAJ9LS1kwImbttTOcWxc=";
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
        "aarch64-linux" = "sha256-eZZ5Ynj81KwFsU5emPtYZ2CxO8MFvWbJnCHs+L88KQQ=";
        "x86_64-linux" = "sha256-yUAyyO1NFav1EptrRYGSzC8dxCxYVj0FmzHk8IckFZM=";
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

      chmod -R +w node_modules/@goauthentik
      rm -R node_modules/@goauthentik/api
      ln -sn ${client-ts} node_modules/@goauthentik/api

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

  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      # https://github.com/goauthentik/authentik/pull/16324
      django = final.django_5;

      ak-guardian = final.buildPythonPackage {
        pname = "ak-guardian";
        inherit version src meta;
        pyproject = true;

        sourceRoot = "${src.name}/packages/ak-guardian";

        build-system = with final; [ hatchling ];

        propagatedBuildInputs = with final; [
          django
          typing-extensions
        ];
      };

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
          substituteInPlace authentik/root/settings.py \
            --replace-fail 'Path(__file__).absolute().parent.parent.parent' "Path(\"$out\")"
          substituteInPlace authentik/lib/default.yml \
            --replace-fail '/blueprints' "$out/blueprints"
          substituteInPlace authentik/stages/email/utils.py \
            --replace-fail 'web/' '${webui}/'
          # allways allow file upload if the data directoy exists
          substituteInPlace authentik/admin/files/backends/file.py \
            --replace-fail "and (self._base_dir.is_mount() or (self._base_dir / self.usage.value).is_mount())" ""
        '';

        build-system = [
          final.hatchling
        ];

        pythonRemoveDeps = [ "dumb-init" ];

        pythonRelaxDeps = true;

        dependencies =
          with final;
          [
            ak-guardian
            argon2-cffi
            cachetools
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

  # Provide a setup-hook to configure the Go vendor directory with up-to-date API bindings.
  # This is done to avoid the `vendorHash` depending on anything in the `client-go` build (e.g.
  # openapi-generator-cli version updates changing the produced content) and invalidating the hash.
  apiGoVendorHook =
    makeSetupHook
      {
        name = "authentik-api-go-vendor-hook";
      }
      (
        writeShellScript "authentik-api-go-vendor-hook" ''
          authentikApiGoVendorHook() {
            chmod -R +w vendor/goauthentik.io/api
            rm -rf vendor/goauthentik.io/api/v3
            cp -r ${client-go} vendor/goauthentik.io/api/v3

            echo "Finished authentikApiGoVendorHook"
          }

          # don't run for FOD, e.g. the `goModules` build
          if [ -z ''${outputHash-} ]; then
            postConfigureHooks+=(authentikApiGoVendorHook)
          fi
        ''
      );

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

    nativeBuildInputs = [ apiGoVendorHook ];

    env.CGO_ENABLED = 0;

    # calculate the vendorHash without other dependencies, so it is only based on the `go.sum` file
    overrideModAttrs.postPatch = "";

    vendorHash = "sha256-pdQg02f1K4nOhsnadoplQYOhEybqZxn+yDQRN5RNygM=";

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
    inherit proxy apiGoVendorHook;
    outposts = callPackages ./outposts.nix {
      inherit (proxy) vendorHash;
      inherit apiGoVendorHook;
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  meta = meta // {
    mainProgram = "ak";
  };
}
