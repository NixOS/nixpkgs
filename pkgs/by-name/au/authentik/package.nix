{
  lib,
  applyPatches,
  fetchFromGitHub,
  newScope,
  nodejs_24,
  python314,
}:
# Use makeScope to allow overriding the attributes of all dependencies.
#
# Example overlays:
#
# ```
# (final: prev: {
#   authentik = prev.authentik.overrideScope (finalScope: prevScope: {
#     core = prevScope.core.overrideAttrs { ... };
#   });
# })
# ```
#
# ```
# (final: prev: {
#   authentik = prev.authentik.appendPythonDependencies (ps: [ps.pillow]);
# })
# ```
(lib.makeScope newScope (
  scope:
  let
    source = lib.fromJSON (lib.readFile ./source.json);

    inherit (scope) callPackage;

    mkPackageBuilder =
      exts: mkDerivation: userFn:
      mkDerivation (lib.extends (lib.composeManyExtensions exts) userFn);

    # Set some meta defaults
    defaultsLayer = finalAttrs: prevAttrs: {
      version = prevAttrs.version or scope.version;
      pos = builtins.unsafeGetAttrPos "pname" prevAttrs;
      meta = prevAttrs.meta or { } // {
        description = prevAttrs.meta.description or "Authentication glue you need";
        changelog =
          prevAttrs.meta.changelog
            or "https://github.com/goauthentik/authentik/releases/tag/version%2F${finalAttrs.version}";
        homepage = prevAttrs.meta.homepage or "https://goauthentik.io/";
        license = prevAttrs.meta.license or lib.licenses.mit;
        platforms =
          prevAttrs.meta.platforms or [
            "aarch64-linux"
            "x86_64-linux"
          ];
        maintainers =
          prevAttrs.meta.maintainers or (with lib.maintainers; [
            jvanbruegge
            risson
          ]);
      };
    };

    # Apply the final source tree and sourceRoot
    sourceLayer = finalAttrs: prevAttrs: {
      src = scope.patchedSrc;
      sourceRoot =
        if prevAttrs ? sourceDir then "${scope.patchedSrc.name}/${prevAttrs.sourceDir}" else "";
      sourceDir = null;
    };

    # Replace the bundled API clients with source build ones.
    withClientsLayer = finalAttrs: prevAttrs: {
      postUnpack =
        let
          packages = "${finalAttrs.src.name}/packages";
          webPackages = "${finalAttrs.src.name}/web/packages";
        in
        (prevAttrs.postUnpack or "")
        + ''
          chmod u+w ${packages}
          chmod -R u+w ${packages}/client-{go,rust,ts}
          rm -rf ${packages}/client-{go,rust,ts}
          cp -r ${scope.client-go} ${packages}/client-go
          cp -r ${scope.client-rust} ${packages}/client-rust
          cp -r ${scope.client-ts} ${packages}/client-ts

          chmod u+w ${webPackages}
          chmod -R u+w ${webPackages}/client-ts
          rm -rf ${webPackages}/client-ts
          cp -r ${scope.client-ts} ${webPackages}/client-ts
        '';
    };

    # Apply defaults shared by all Go outposts
    goOutpostLayer = finalAttrs: prevAttrs: {
      outpostName = null;

      pos = builtins.unsafeGetAttrPos "outpostName" prevAttrs;

      pname = "authentik-${prevAttrs.outpostName}-outpost";

      inherit (scope.server) vendorHash;

      env.CGO_ENABLED = 0;

      subPackages = [ "cmd/${prevAttrs.outpostName}" ];

      meta = prevAttrs.meta or { } // {
        homepage =
          prevAttrs.meta.homepage or "https://goauthentik.io/docs/providers/${prevAttrs.outpostName}/";
        mainProgram = prevAttrs.meta.mainProgram or prevAttrs.outpostName;
      };
    };
  in
  {
    mkComponent = mkPackageBuilder [
      defaultsLayer
      sourceLayer
    ];

    mkComponentWithClients = mkPackageBuilder [
      defaultsLayer
      sourceLayer
      withClientsLayer
    ];

    mkGoOutpost = mkPackageBuilder [
      defaultsLayer
      sourceLayer
      withClientsLayer
      goOutpostLayer
    ];

    nodejs = nodejs_24;

    inherit (source.authentik) version;

    src = fetchFromGitHub {
      owner = "goauthentik";
      repo = "authentik";
      tag = "version/${source.authentik.version}";
      hash = source.authentik.hash;
    };

    patches = [ ];

    # Add additional patches to apply to the authentik source tree.
    appendPatches =
      patches:
      scope.overrideScope (
        finalScope: prevScope: {
          patches = prevScope.patches ++ patches;
        }
      );

    patchedSrc =
      if scope.patches == [ ] then
        scope.src
      else
        applyPatches {
          name = "${scope.src.name or "authentik-source"}-patched";
          inherit (scope) src patches;
        };

    extraPythonDependencies = [ ];

    # Add additional python dependencies to the authentik environemnt.
    # This makes them available during policy evaluation.
    appendPythonDependencies =
      dependenciesFn:
      scope.overrideScope (
        finalScope: prevScope: {
          extraPythonDependencies =
            prevScope.extraPythonDependencies ++ dependenciesFn finalScope.python.pkgs;
        }
      );

    client-go = callPackage (
      {
        go,
        mkComponent,
        openapi-generator-cli,
        python,
        stdenvNoCC,
      }:
      mkComponent stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik-client-go";
        sourceDir = "packages/client-go";

        nativeBuildInputs = [
          openapi-generator-cli
          go
          (python.withPackages (ps: [ ps.pyyaml ]))
        ];

        buildPhase = ''
          runHook preBuild

          python ../../scripts/api_filter_schema.py ../../schema.yml schema.yml operation_ids
          openapi-generator-cli generate \
            -i schema.yml -o $out \
            -g go \
            -c config.yaml

          cd $out
          rm -r .openapi-generator api go.mod go.sum
          gofmt -w $out

          runHook postBuild
        '';
      })
    ) { };

    client-rust = callPackage (
      {
        mkComponent,
        openapi-generator-cli,
        python,
        stdenvNoCC,
      }:
      mkComponent stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik-client-rust";
        sourceDir = "packages/client-rust";

        nativeBuildInputs = [
          openapi-generator-cli
          (python.withPackages (ps: [ ps.pyyaml ]))
        ];

        buildPhase = ''
          runHook preBuild

          mkdir $out
          cp .openapi-generator-ignore Cargo.toml $out

          python ../../scripts/api_filter_schema.py ../../schema.yml schema.yml operation_ids
          # openapi-generator-cli >= 7.22 enables useChrono by default. Remove once upstream has migrated.
          openapi-generator-cli generate \
            -i schema.yml -o $out \
            -g rust \
            -c config.yaml \
            --additional-properties=packageVersion=${finalAttrs.version},useChrono=false

          cd $out
          sed -i 's/models::models::/models::/g' src/apis/*
          rm -rf .openapi-generator api/openapi.yaml schema.yml

          runHook postBuild
        '';
      })
    ) { };

    client-ts = callPackage (
      {
        mkComponent,
        nodejs,
        openapi-generator-cli,
        stdenvNoCC,
        typescript,
      }:
      mkComponent stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik-client-ts";
        sourceDir = "packages/client-ts";

        postPatch = ''
          substituteInPlace config.yaml \
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
            -i ../../schema.yml -o $out \
            -g typescript-fetch \
            -c config.yaml \
            --additional-properties=npmVersion=${finalAttrs.version} \
            --git-repo-id authentik --git-user-id goauthentik

          cd $out
          rm -r .openapi-generator
          npm run build

          runHook postBuild
        '';
      })
    ) { };

    # prefetch-npm-deps does not save all dependencies even though the lockfile is fine
    webui-deps = callPackage (
      {
        cacert,
        mkComponent,
        nodejs,
        stdenvNoCC,
      }:
      mkComponent stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik-webui-deps";
        sourceDir = "web";

        outputHash =
          source.webuiHashes.${stdenvNoCC.hostPlatform.system}
            or (throw "authentik-webui-deps: unsupported host platform");
        outputHashMode = "recursive";

        postUnpack = ''
          chmod -R u+w $sourceRoot/..
        '';

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
      })
    ) { };

    webui = callPackage (
      {
        chromedriver,
        mkComponentWithClients,
        nodejs,
        stdenvNoCC,
        webui-deps,
      }:
      mkComponentWithClients stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik-webui";
        sourceDir = "web";

        postPatch = ''
          substituteInPlace packages/core/version/node.js \
            --replace-fail 'const prerelease = ' 'const prerelease = false; // ' \
            --replace-fail 'import PackageJSON from "../../../../package.json" with { type: "json" };' "" \
            --replace-fail '(PackageJSON.version);' '"${finalAttrs.version}";'
        '';

        nativeBuildInputs = [
          nodejs
        ];

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
      })
    ) { };

    # Extract the default blueprints, so they can be customized easily. This can be done by:
    # - using `overrideScope`, which causes some rebuilds
    # - setting the `AUTHENTIK_BLUEPRINTS_DIR` variable for the worker service
    #
    # 'additionalPaths` are copied with symlinks resolved, because they can cause issues at runtime.
    blueprints = callPackage (
      {
        mkComponent,
        rsync,
        stdenvNoCC,
        # additional directories to copy into the output
        additionalPaths ? [ ],
      }:
      mkComponent stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik-blueprints";

        dontBuild = true;

        installPhase = ''
          runHook preInstall

          cp -rL blueprints $out

          ${lib.concatMapStrings (p: ''
            echo "Copying blueprints from ${p}"
            ${lib.getExe rsync} -rL --info=name ${p}/ $out/
          '') additionalPaths}

          runHook postInstall
        '';
      })
    ) { };

    python = python314.override {
      self = scope.python;
      packageOverrides =
        final: prev:
        let
          mkPythonComponent = scope.mkComponent final.buildPythonPackage;
        in
        {
          django = final.django_5;

          ak-guardian = mkPythonComponent (finalAttrs: {
            pname = "ak-guardian";
            sourceDir = "packages/ak-guardian";

            pyproject = true;

            build-system = with final; [ hatchling ];

            propagatedBuildInputs = with final; [
              django
              typing-extensions
            ];
          });

          django-channels-postgres = mkPythonComponent (finalAttrs: {
            pname = "django-channels-postgres";
            sourceDir = "packages/django-channels-postgres";

            pyproject = true;

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
          });

          django-dramatiq-postgres = mkPythonComponent (finalAttrs: {
            pname = "django-dramatiq-postgres";
            sourceDir = "packages/django-dramatiq-postgres";

            pyproject = true;

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
          });

          django-postgres-cache = mkPythonComponent (finalAttrs: {
            pname = "django-postgres-cache";
            sourceDir = "packages/django-postgres-cache";

            pyproject = true;

            build-system = with final; [ hatchling ];

            propagatedBuildInputs = with final; [
              django
              django-postgres-extra
            ];
          });

          authentik-django = mkPythonComponent (finalAttrs: {
            pname = "authentik-django";
            pyproject = true;

            postPatch = ''
              substituteInPlace authentik/root/settings.py \
                --replace-fail 'Path(__file__).absolute().parent.parent.parent' "Path(\"$out\")"
              substituteInPlace authentik/lib/default.yml \
                --replace-fail '/blueprints' "${scope.blueprints}"
              substituteInPlace authentik/stages/email/utils.py \
                --replace-fail 'web/' '${scope.webui}/'
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
                gssapi
                gunicorn
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
              mkdir -p $out/web
              cp -r lifecycle manage.py $out/${prev.python.sitePackages}/
              cp -r ${scope.webui}/dist ${scope.webui}/authentik $out/web/
              ln -s $out/${prev.python.sitePackages}/authentik $out/authentik
              ln -s $out/${prev.python.sitePackages}/lifecycle $out/lifecycle
            '';
          });
        };
    };

    server = callPackage (
      {
        buildGoModule,
        mkComponentWithClients,
        python,
      }:
      mkComponentWithClients buildGoModule (finalAttrs: {
        pname = "authentik-server";

        postPatch = ''
          substituteInPlace internal/gounicorn/gounicorn.go \
            --replace-fail './lifecycle' "${python.pkgs.authentik-django}/lifecycle"
          substituteInPlace web/static.go \
            --replace-fail './web' "${python.pkgs.authentik-django}/web"
          substituteInPlace internal/web/static.go \
            --replace-fail './web' "${python.pkgs.authentik-django}/web"
        '';

        env.CGO_ENABLED = 0;

        # calculate the vendorHash without other dependencies, so it is only based on the `go.sum` file
        overrideModAttrs.postPatch = "";

        vendorHash = source.serverVendorHash;

        postInstall = ''
          mv $out/bin/server $out/bin/authentik-server
        '';

        subPackages = [ "cmd/server" ];

        meta.mainProgram = "authentik-server";
      })
    ) { };

    core = callPackage (
      {
        clang,
        cmake,
        go,
        mkComponentWithClients,
        perl,
        python,
        rustPlatform,
      }:
      mkComponentWithClients rustPlatform.buildRustPackage (finalAttrs: {
        pname = "authentik-core";

        nativeBuildInputs = [
          clang
          cmake
          go
          perl
          python
        ];

        cargoHash = source.coreCargoHash;

        cargoBuildNoDefaultFeatures = true;
        cargoBuildFeatures = [ "core" ];

        env.RUSTFLAGS = "--cfg tokio_unstable";
        # See https://github.com/goauthentik/authentik/blob/version/2026.5.0/lifecycle/container/Dockerfile#L143-L144
        env.AWS_LC_FIPS_SYS_CC = "clang";

        # there are currently no tests, so dont build test dependencies
        doCheck = false;

        meta.mainProgram = "authentik";
      })
    ) { };

    authentik = callPackage (
      {
        core,
        extraPythonDependencies,
        makeWrapper,
        mkComponentWithClients,
        outposts,
        python,
        server,
        stdenvNoCC,
      }:
      mkComponentWithClients stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "authentik";

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
                (python.withPackages (ps: [ ps.authentik-django ] ++ extraPythonDependencies))
                core
                server
              ]
            } \
            --set TMPDIR /dev/shm \
            --set PYTHONDONTWRITEBYTECODE 1 \
            --set PYTHONUNBUFFERED 1
          runHook postInstall
        '';

        nativeBuildInputs = [ makeWrapper ];

        passthru.components = scope;
        passthru.outposts = outposts;
        passthru.tests.updateScript-lint = callPackage (
          {
            runCommand,
            python,
          }:
          runCommand "authentik-updateScript-lint"
            {
              buildInputs = [
                (python.withPackages (ps: [
                  ps.pydantic
                  ps.ruff
                  ps.stackprinter
                  ps.ty
                  ps.types-requests
                ]))
              ];
            }
            ''
              echo "# run ty"
              ty check --error-on-warning ${./update.py}
              echo "# run ruff check"
              ruff check ${./update.py}
              echo "# run ruff format"
              ruff format --check --diff ${./update.py}

              touch $out
            ''
        ) { };
        passthru.updateScript = {
          command = [ ./update.py ];
          supportedFeatures = [ "commit" ];
        };

        meta.mainProgram = "ak";
      })
      // {
        overrideScope = f: (scope.overrideScope f).authentik;

        appendPatches = patches: (scope.appendPatches patches).authentik;

        appendPythonDependencies =
          dependenciesFn: (scope.appendPythonDependencies dependenciesFn).authentik;
      }
    ) { };

    outposts = scope.callPackage ./outposts.nix { };
  }
)).authentik
