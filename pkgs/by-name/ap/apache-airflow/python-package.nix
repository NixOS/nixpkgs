{
  lib,
  stdenv,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # javascript
  fetchPnpmDeps,
  nodejs,
  pnpm,
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
  trove-classifiers,
  types-requests,
  typing-extensions,
  universal-pathlib,
  uuid6,
  uvicorn,

  enabledProviders,
}:
let
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "airflow";
    tag = version;
    hash = "sha256-wC6C0jhCA76/+KhBQbe3WeSGqR6FwaudCT5xPV39Z6c=";
  };

  airflowUi = stdenv.mkDerivation rec {
    pname = "airflow-ui-assets";
    inherit src version;
    sourceRoot = "${src.name}/airflow-core/src/airflow/ui";

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      pname = "airflow-ui";
      inherit sourceRoot src version;
      fetcherVersion = 1;
      hash = "sha256-UcEFQkDZ9Ye+VfyJ9rdZKe0wilTgO4dMsULABWfL2Co=";
    };

    buildPhase = ''
      pnpm install
      pnpm build
    '';

    installPhase = ''
      mkdir -p $out/share/airflow/ui
      cp -r dist $out/share/airflow/ui/
    '';
  };

  airflowSimpleAuthUi = stdenv.mkDerivation rec {
    pname = "airflow-simple-ui-assets";
    inherit src version;
    sourceRoot = "${src.name}/airflow-core/src/airflow/api_fastapi/auth/managers/simple/ui";

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      pname = "simple-auth-manager-ui";
      inherit sourceRoot src version;
      fetcherVersion = 1;
      hash = "sha256-8nZdWnhERUkiaY8USyy/a/j+dMksjmEzCabSkysndSE=";
    };

    buildPhase = ''
      pnpm install
      pnpm build
    '';

    installPhase = ''
      mkdir -p $out/share/airflow/simple-ui
      cp -r dist $out/share/airflow/simple-ui/
    '';
  };

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

      inherit src;
      sourceRoot = "${src.name}/providers/${lib.replaceStrings [ "_" ] [ "/" ] provider}";

      buildInputs = [ flit-core ];

      dependencies = map (dep: python.pkgs.${dep}) providers.${provider}.deps;

      pythonRemoveDeps = [
        "apache-airflow"
      ];

      pythonRelaxDeps = [
        "flit-core"
      ];
    };

  airflowCore = buildPythonPackage {
    pname = "apache-airflow-core";
    inherit src version;
    pyproject = true;

    sourceRoot = "${src.name}/airflow-core";

    postPatch = ''
      # remove cyclic dependency
      sed -i -E 's/"apache-airflow-task-sdk[^"]+",//' pyproject.toml

      substituteInPlace pyproject.toml \
        --replace-fail "GitPython==3.1.45" "GitPython" \
        --replace-fail "hatchling==1.27.0" "hatchling" \
        --replace-fail "trove-classifiers==2025.9.11.17" "trove-classifiers"

      # Copy built UI assets
      cp -r ${airflowUi}/share/airflow/ui/dist src/airflow/ui/
      cp -r ${airflowSimpleAuthUi}/share/airflow/simple-ui/dist src/airflow/api_fastapi/auth/managers/simple/ui/
    '';

    build-system = [
      gitdb
      gitpython
      hatchling
      packaging
      smmap
      tomli
      trove-classifiers
    ];

    dependencies = [
      a2wsgi
      aiosqlite
      alembic
      argcomplete
      asgiref
      attrs
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
      # Temporary to fix CI only:
      # https://github.com/apache/airflow/commit/c474be9ff06cf16bf96f93de9a09e30ffc476bee
      "fastapi"
      "universal-pathlib"
    ];
  };

  taskSdk = buildPythonPackage {
    pname = "task-sdk";
    inherit src version;
    pyproject = true;

    sourceRoot = "${src.name}/task-sdk";

    postPatch = ''
      # resolve cyclic dependency
      sed -i -E 's/"apache-airflow-core[^"]+",//' pyproject.toml
    '';

    build-system = [
      hatchling
    ];

    dependencies = [
      asgiref
      attrs
      babel
      colorlog
      fsspec
      greenback
      httpx
      jinja2
      methodtools
      msgspec
      pendulum
      psutil
      pydantic
      pygtrie
      python-dateutil
      requests
      retryhttp
      structlog
      tenacity
      types-requests
    ];
  };

in
buildPythonPackage rec {
  pname = "apache-airflow";
  inherit src version;
  pyproject = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "GitPython==3.1.45" "GitPython" \
      --replace-fail "hatchling==1.27.0" "hatchling" \
      --replace-fail "trove-classifiers==2025.9.11.17" "trove-classifiers"
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
    changelog = "https://airflow.apache.org/docs/apache-airflow/${version}/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      taranarmo
    ];
    mainProgram = "airflow";
  };
}
