{
  lib,
  stdenv,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # javascript
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,

  # python
  a2wsgi,
  aiosqlite,
  alembic,
  argcomplete,
  asgiref,
  attrs,
  babel,
  buildPythonPackage,
  cachetools,
  cadwyn,
  colorlog,
  cron-descriptor,
  croniter,
  cryptography,
  deprecated,
  dill,
  fastapi,
  flit-core,
  fsspec,
  gitdb,
  gitpython,
  greenback,
  hatchling,
  httpx,
  importlib-metadata,
  isoduration,
  itsdangerous,
  jinja2,
  jsonschema,
  lazy-object-proxy,
  libcst,
  linkify-it-py,
  lockfile,
  methodtools,
  msgspec,
  natsort,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  packaging,
  pathspec,
  pendulum,
  pluggy,
  psutil,
  pydantic,
  pygments,
  pygtrie,
  pyjwt,
  python,
  python-daemon,
  python-dateutil,
  python-slugify,
  pyyaml,
  requests,
  retryhttp,
  rich,
  rich-argparse,
  rich-click,
  setproctitle,
  smmap,
  sqlalchemy,
  sqlalchemy-jsonfield,
  sqlalchemy-utils,
  starlette,
  structlog,
  svcs,
  tabulate,
  tenacity,
  termcolor,
  tomli,
  tomlkit,
  trove-classifiers,
  types-requests,
  typing-extensions,
  universal-pathlib,
  uuid6,
  uvicorn,

  enabledProviders,
}:
buildPythonPackage (
  finalAttrs:
  let
    inherit (finalAttrs) src version;

    airflowUi = stdenv.mkDerivation (uiAttrs: {
      pname = "airflow-ui-assets";
      inherit src version;
      sourceRoot = "${src.name}/airflow-core/src/airflow/ui";

      # vite build resolves "localhost" during the build, which the darwin
      # sandbox blocks by default (getaddrinfo ENOTFOUND localhost).
      __darwinAllowLocalNetworking = stdenv.hostPlatform.isDarwin;

      nativeBuildInputs = [
        nodejs
        pnpm_10
        pnpmConfigHook
      ];

      pnpmDeps = fetchPnpmDeps {
        pname = "airflow-ui";
        inherit src version;
        pnpm = pnpm_10;
        sourceRoot = uiAttrs.sourceRoot;
        fetcherVersion = 3;
        hash = "sha256-+f/AcJSQyvu3YCT6p4wvbNXz/xM0WN8N+MWT7iLlFEk=";
      };

      buildPhase = ''
        pnpm install
        pnpm build
      '';

      installPhase = ''
        mkdir -p $out/share/airflow/ui
        cp -r dist $out/share/airflow/ui/
      '';
    });

    airflowSimpleAuthUi = stdenv.mkDerivation (simpleUiAttrs: {
      pname = "airflow-simple-ui-assets";
      inherit src version;
      sourceRoot = "${src.name}/airflow-core/src/airflow/api_fastapi/auth/managers/simple/ui";

      __darwinAllowLocalNetworking = stdenv.hostPlatform.isDarwin;

      nativeBuildInputs = [
        nodejs
        pnpm_10
        pnpmConfigHook
      ];

      pnpmDeps = fetchPnpmDeps {
        pname = "simple-auth-manager-ui";
        inherit src version;
        pnpm = pnpm_10;
        sourceRoot = simpleUiAttrs.sourceRoot;
        fetcherVersion = 3;
        hash = "sha256-jLCTKdBdKQufVWQ1XRzOVN4jVC0YAcP+jnz5R966zUY=";
      };

      buildPhase = ''
        pnpm install
        pnpm build
      '';

      installPhase = ''
        mkdir -p $out/share/airflow/simple-ui
        cp -r dist $out/share/airflow/simple-ui/
      '';
    });

    requiredProviders = [
      "common_compat"
      "common_io"
      "common_sql"
      "smtp"
      "standard"
    ];

    providers = import ./providers.nix;

    buildProvider =
      provider:
      buildPythonPackage {
        pname = "apache-airflow-providers-${provider}";
        version = providers.${provider}.version;
        pyproject = true;

        dontCheckPythonMetadata = true;

        dontCheckRuntimeDeps = true;

        inherit src;
        sourceRoot = "${src.name}/providers/${lib.replaceStrings [ "_" ] [ "/" ] provider}";

        postPatch = ''
          # relax dependencies
          sed -i -E 's/"flit_core==[^"]+"/"flit_core"/' pyproject.toml
          sed -i -E 's/"hatchling==[^"]+"/"hatchling"/' pyproject.toml
          sed -i -E 's/"packaging==[^"]+"/"packaging"/' pyproject.toml
          sed -i -E 's/"pathspec==[^"]+"/"pathspec"/' pyproject.toml
          sed -i -E 's/"pluggy==[^"]+"/"pluggy"/' pyproject.toml
          sed -i -E 's/"tomlkit==[^"]+"/"tomlkit"/' pyproject.toml
          sed -i -E 's/"trove-classifiers==[^"]+"/"trove-classifiers"/' pyproject.toml
        '';

        build-system = [
          flit-core
          hatchling
          packaging
          pathspec
          pluggy
          tomlkit
          trove-classifiers
        ];

        dependencies = map (dep: python.pkgs.${dep}) providers.${provider}.deps;

        pythonRemoveDeps = [
          "apache-airflow"
        ];
      };

    taskSdk = buildPythonPackage {
      pname = "apache-airflow-task-sdk";
      inherit src version;
      pyproject = true;

      dontCheckPythonMetadata = true;

      sourceRoot = "${src.name}/task-sdk";

      postPatch = ''
        # resolve cyclic dependency
        sed -i -E 's/"apache-airflow-core[^"]+",//' pyproject.toml

        # relax dependencies
        sed -i -E 's/"hatchling==[^"]+"/"hatchling"/' pyproject.toml
        sed -i -E 's/"packaging==[^"]+"/"packaging"/' pyproject.toml
        sed -i -E 's/"pathspec==[^"]+"/"pathspec"/' pyproject.toml
        sed -i -E 's/"pluggy==[^"]+"/"pluggy"/' pyproject.toml
        sed -i -E 's/"tomlkit==[^"]+"/"tomlkit"/' pyproject.toml
        sed -i -E 's/"trove-classifiers==[^"]+"/"trove-classifiers"/' pyproject.toml

        # task-sdk needs config.yml from core subpackage
        mkdir -p src/airflow/config_templates
        cp ../airflow-core/src/airflow/config_templates/* src/airflow/config_templates/
      '';

      build-system = [
        hatchling
        packaging
        pathspec
        pluggy
        tomlkit
        trove-classifiers
      ];

      dependencies = [
        asgiref
        attrs
        babel
        colorlog
        fsspec
        greenback
        httpx
        isoduration
        jinja2
        jsonschema
        methodtools
        msgspec
        opentelemetry-api
        packaging
        pathspec
        pendulum
        pluggy
        psutil
        pydantic
        pygtrie
        python-dateutil
        requests
        retryhttp
        structlog
        tenacity
        types-requests
        typing-extensions
      ];
    };

    airflowCore = buildPythonPackage {
      pname = "apache-airflow-core";
      inherit src version;
      pyproject = true;

      dontCheckPythonMetadata = true;

      sourceRoot = "${src.name}/airflow-core";

      postPatch = ''
        # remove cyclic dependency
        sed -i -E 's/"apache-airflow-task-sdk[^"]+",//' pyproject.toml

        # relax dependencies
        sed -i -E 's/"hatchling==[^"]+"/"hatchling"/' pyproject.toml
        sed -i -E 's/"packaging==[^"]+"/"packaging"/' pyproject.toml
        sed -i -E 's/"GitPython==[^"]+"/"GitPython"/' pyproject.toml
        sed -i -E 's/"pathspec==[^"]+"/"pathspec"/' pyproject.toml
        sed -i -E 's/"pluggy==[^"]+"/"pluggy"/' pyproject.toml
        sed -i -E 's/"smmap==[^"]+"/"smmap"/' pyproject.toml
        sed -i -E 's/"tomlkit==[^"]+"/"tomlkit"/' pyproject.toml
        sed -i -E 's/"trove-classifiers==[^"]+"/"trove-classifiers"/' pyproject.toml

        # fixes for release26.05 branch
        sed -i -E 's/"croniter>=[^"]+"/"croniter"/' pyproject.toml
        sed -i -E 's/"sqlalchemy\[asyncio\]>=[^"]+"/"sqlalchemy[asyncio]"/' pyproject.toml

        # Copy built UI assets
        cp -r ${airflowUi}/share/airflow/ui/dist src/airflow/ui/
        cp -r ${airflowSimpleAuthUi}/share/airflow/simple-ui/dist src/airflow/api_fastapi/auth/managers/simple/ui/
      '';

      build-system = [
        gitdb
        gitpython
        hatchling
        packaging
        pathspec
        pluggy
        smmap
        tomli
        tomlkit
        trove-classifiers
      ];

      dependencies = [
        a2wsgi
        aiosqlite
        alembic
        argcomplete
        asgiref
        attrs
        cachetools
        cadwyn
        colorlog
        cron-descriptor
        croniter
        cryptography
        deprecated
        dill
        fastapi
        httpx
        importlib-metadata
        itsdangerous
        jinja2
        jsonschema
        lazy-object-proxy
        libcst
        linkify-it-py
        lockfile
        methodtools
        msgspec
        natsort
        opentelemetry-api
        opentelemetry-exporter-otlp
        packaging
        pathspec
        pendulum
        pluggy
        psutil
        pydantic
        pygments
        pygtrie
        pyjwt
        python-daemon
        python-dateutil
        python-slugify
        pyyaml
        requests
        rich
        rich-argparse
        rich-click
        setproctitle
        sqlalchemy
        sqlalchemy-jsonfield
        sqlalchemy-utils
        starlette
        structlog
        svcs
        tabulate
        taskSdk
        tenacity
        termcolor
        typing-extensions
        universal-pathlib
        uuid6
        uvicorn
      ]
      ++ (map buildProvider requiredProviders);

      pythonRelaxDeps = [
        "starlette"
        "fastapi"
      ];
    };
  in
  {
    pname = "apache-airflow";
    version = "3.3.2";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "apache";
      repo = "airflow";
      tag = finalAttrs.version;
      hash = "sha256-iWr1LYq+lThZU7b7CmrIWFbg20bFy+SghrBpE6asgrg=";
    };

    pyproject = true;

    postPatch = ''
      # relax dependencies
      sed -i -E 's/"hatchling==[^"]+"/"hatchling"/' pyproject.toml
      sed -i -E 's/"packaging==[^"]+"/"packaging"/' pyproject.toml
      sed -i -E 's/"pathspec==[^"]+"/"pathspec"/' pyproject.toml
      sed -i -E 's/"pluggy==[^"]+"/"pluggy"/' pyproject.toml
      sed -i -E 's/"tomlkit==[^"]+"/"tomlkit"/' pyproject.toml
      sed -i -E 's/"trove-classifiers==[^"]+"/"trove-classifiers"/' pyproject.toml
    '';

    nativeBuildInputs = [ writableTmpDirAsHomeHook ];

    build-system = [
      gitdb
      gitpython
      hatchling
      packaging
      pathspec
      pluggy
      smmap
      tomli
      tomlkit
      trove-classifiers
    ];

    dependencies = [
      airflowCore # subpackage from airflow src
      taskSdk # subpackage from airflow src
    ]
    ++ (map buildProvider enabledProviders);

    postInstall = ''
      # Create a symlink to the airflow-core package
      mkdir -p $out/bin
      ln -s ${airflowCore}/bin/airflow $out/bin/airflow
    '';

    installCheckPhase = ''
      runHook preInstallCheck

      $out/bin/airflow version
      $out/bin/airflow db reset -y

      runHook postInstallCheck
    '';

    pythonImportsCheck = [
      "airflow"
    ]
    ++ lib.concatMap (provider: providers.${provider}.imports) (requiredProviders ++ enabledProviders);

    passthru.updateScript = ./update.sh;
    passthru.airflowUi = airflowUi;
    passthru.airflowSimpleAuthUi = airflowSimpleAuthUi;

    # Note on testing the web UI:
    # You can (manually) test the web UI as follows:
    #
    #   nix shell .#apache-airflow
    #   airflow version
    #   airflow db reset  # WARNING: this will wipe any existing db state you might have!
    #   airflow standalone
    #
    # Then navigate to the localhost URL using the credentials printed, try
    # triggering the 'example_bash_operator' DAG and see if it reports success.

    meta = {
      description = "Platform to programmatically author, schedule and monitor workflows";
      homepage = "https://airflow.apache.org/";
      changelog = "https://airflow.apache.org/docs/apache-airflow/${finalAttrs.version}/release_notes.html";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        taranarmo
      ];
      mainProgram = "airflow";
    };
  }
)
