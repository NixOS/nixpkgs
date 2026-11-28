{
  lib,
  stdenvNoCC,
  callPackages,
  clangStdenv,
  cmake,
  fetchFromGitHub,
  fetchPnpmDeps,
  aws-lc,
  buildGo127Module,
  bash,
  chromedriver,
  nodejs_24,
  python314,
  makeWrapper,
  openapi-generator-cli,
  perl,
  pnpm_12,
  pnpmBuildHook,
  pnpmConfigHook,
  pkg-config,
  rustPlatform,
  go,
  typescript_7,
  zstd,
  makeSetupHook,
  writeShellScript,
}:

let
  nodejs = nodejs_24;
  pnpm = pnpm_12;

  version = "2026.8.5";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    tag = "version/${version}";
    hash = "sha256-gdhGKCfsMUrWyFnf5TaaHM2ZQ1WYgTLOgGg4DlCaUHU=";
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
    inherit version src meta;

    sourceRoot = "${src.name}/packages/client-go";

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

      cd $out
      rm -rf test
      rm -f go.mod go.sum
      rm -f .travis.yml git_push.sh

      runHook postInstall
    '';
  };

  client-ts = stdenvNoCC.mkDerivation {
    pname = "authentik-client-ts";
    inherit version src meta;

    postPatch = ''
      substituteInPlace ./packages/client-ts/config.yaml \
        --replace-fail '/local' "$(pwd)/packages/client-ts"
    '';

    nativeBuildInputs = [
      nodejs
      openapi-generator-cli
      typescript_7
    ];

    buildPhase = ''
      runHook preBuild

      openapi-generator-cli generate \
        -i ./schema.yml -o $out \
        -g typescript-fetch \
        -c ./packages/client-ts/config.yaml \
        --additional-properties=npmVersion=${version} \
        --git-repo-id authentik --git-user-id goauthentik

      cd $out
      npm run build

      runHook postBuild
    '';
  };

  website-deps = fetchPnpmDeps {
    pname = "authentik-website-deps";
    inherit
      src
      version
      meta
      pnpm
      ;

    sourceRoot = "${src.name}/website";
    pnpmRoot = "website";
    fetcherVersion = 5;

    hash = "sha256-jABdo9uLHj01CGxOSmt1kqsL6EZ1fABwXGuhDXBaHbM=";
  };

  website = stdenvNoCC.mkDerivation {
    pname = "authentik-website";
    inherit src version meta;

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
      pnpmBuildHook
    ];

    pnpmBuildScript = "build:api";
    pnpmRoot = "website";
    pnpmDeps = website-deps;

    preBuild = ''
      patchShebangs --build website/node_modules/.bin/docusaurus

      mkdir packages/docusaurus-config/node_modules
      ln -s ../../../website/node_modules/deepmerge-ts packages/docusaurus-config/node_modules/deepmerge-ts
      ln -s ../../../website/node_modules/prism-react-renderer packages/docusaurus-config/node_modules/prism-react-renderer
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r website/api/build $out/help

      runHook postInstall
    '';
  };

  webui-deps = fetchPnpmDeps {
    pname = "authentik-webui-deps";
    inherit
      src
      version
      meta
      pnpm
      ;

    sourceRoot = "${src.name}/web";
    fetcherVersion = 5;

    hash = "sha256-b7zWY1iDqjfnlAWtPBefkhJzaZNl4H7eNHReXTauINc=";
  };

  webui = stdenvNoCC.mkDerivation {
    pname = "authentik-webui";
    inherit src version meta;

    sourceRoot = "${src.name}/web";

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
      pnpmBuildHook
    ];

    pnpmDeps = webui-deps;

    postPatch = ''
      substituteInPlace packages/core/version/node.js \
        --replace-fail 'import PackageJSON from "../../../../package.json" with { type: "json" };' "" \
        --replace-fail '(PackageJSON.version);' '"${version}";'
    '';

    preBuild = ''
      rm node_modules/@goauthentik/api
      ln -sn ${client-ts} node_modules/@goauthentik/api
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist $out/dist
      cp -r authentik $out/authentik
      runHook postInstall
    '';

    env = {
      NODE_ENV = "production";
      CHROMEDRIVER_FILEPATH = lib.getExe chromedriver;
    };

    npmInstallFlags = [
      "--include=dev"
      "--ignore-scripts"
    ];
  };

  python = python314.override {
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

        nativeBuildInputs = with final; [ pyprojectVersionPatchHook ];

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

        nativeBuildInputs = with final; [ pyprojectVersionPatchHook ];

        pythonRelaxDeps = [
          "structlog"
        ];

        dependencies =
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

        nativeBuildInputs = with final; [ pyprojectVersionPatchHook ];

        pythonRelaxDeps = [
          "structlog"
        ];

        dependencies =
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

        nativeBuildInputs = with final; [ pyprojectVersionPatchHook ];

        propagatedBuildInputs = with final; [
          django
          django-postgres-extra
        ];
      };

      authentik-django = final.buildPythonPackage {
        pname = "authentik";
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

        build-system = with final; [ hatchling ];

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
            msgspec
            opencontainers
            packaging
            paramiko
            psycopg
            pydantic
            pydantic-scim
            pyjwt
            pyrad
            pyroscope-io
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

  worker = (rustPlatform.buildRustPackage.override { stdenv = clangStdenv; }) {
    pname = "authentik-worker";
    inherit version src meta;

    cargoHash = "sha256-dRsfsMH36xICg3WimQz3HX/Qgyt0dve/mvG7QERFzpo=";

    postPatch = ''
      substituteInPlace src/server/mod.rs \
        --replace-fail './lifecycle' "${authentik-django}/lifecycle"
    '';

    preBuild = ''
      ln -s ${webui}/dist web/dist
    '';

    nativeBuildInputs = [
      cmake
      go
      perl
      pkg-config
    ];

    buildInputs = [
      aws-lc
      python
      zstd
    ];

    env = {
      PYO3_PYTHON = lib.getExe python;
      RUSTFLAGS = "--cfg tokio_unstable";
      GOTOOLCHAIN = "local";
      AWS_LC_FIPS_SYS_HOST_CC = "${clangStdenv.cc}/bin/${clangStdenv.cc.targetPrefix}cc";
    };

    cargoBuildFlags = [
      "--package"
      "authentik"
    ];

    # Upstream currently has no Rust tests in this package.
    doCheck = false;
  };

  # Provide a setup-hook to configure the Go source tree with up-to-date API bindings.
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
            chmod -R +w packages/client-go
            rm -rf packages/client-go
            cp -r ${client-go} packages/client-go
            chmod -R +w packages/client-go

            echo "Finished authentikApiGoVendorHook"
          }

          # don't run for FOD, e.g. the `goModules` build
          if [ -z ''${outputHash-} ]; then
            postConfigureHooks+=(authentikApiGoVendorHook)
          fi
        ''
      );

  proxy = buildGo127Module {
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

    vendorHash = "sha256-iFcZo1ZeIAKu58/5YTNyN3H47jGdmD+pLcJCqEe50Zo=";

    postInstall = ''
      mv $out/bin/server $out/bin/authentik-server
      ln -s authentik-server $out/bin/authentik
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
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r lifecycle/ak $out/bin/

    wrapProgram $out/bin/ak \
      --prefix PATH : ${
        lib.makeBinPath [
          worker
          proxy
          (python.withPackages (ps: [ ps.authentik-django ]))
        ]
      } \
      --set TMPDIR /dev/shm \
      --set PYTHONDONTWRITEBYTECODE 1 \
      --set PYTHONUNBUFFERED 1
    runHook postInstall
  '';

  passthru = {
    inherit proxy worker apiGoVendorHook;
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
