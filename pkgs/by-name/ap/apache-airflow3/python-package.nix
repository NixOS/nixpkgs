{
  lib,
  python,
  buildPythonPackage,
  buildPythonApplication,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  # frontend build
  stdenv,
  nodejs,
  pnpm,
  # build dependencies
  gitdb,
  gitpython,
  hatchling,
  packaging,
  pathspec,
  pluggy,
  smmap,
  tomli,
  trove-classifiers,
  # runtime dependencies
  a2wsgi,
  aiosqlite,
  alembic,
  argcomplete,
  asgiref,
  attrs,
  blinker,
  cadwyn,
  colorlog,
  configupdater,
  connexion,
  cron-descriptor,
  croniter,
  cryptography,
  deprecated,
  dill,
  fastapi,
  flask,
  flask-caching,
  flask-session,
  flask-wtf,
  flit-core,
  fsspec,
  google-re2,
  gunicorn,
  httpx,
  itsdangerous,
  jinja2,
  jsonschema,
  lazy-object-proxy,
  libcst,
  linkify-it-py,
  lockfile,
  markdown-it-py,
  markupsafe,
  marshmallow-oneofschema,
  mdit-py-plugins,
  methodtools,
  msgspec,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  pandas,
  pendulum,
  psutil,
  pydantic,
  pygments,
  pyjwt,
  python-daemon,
  python-dateutil,
  python-nvd3,
  python-slugify,
  requests,
  requests-toolbelt,
  retryhttp,
  rfc3339-validator,
  rich,
  rich-argparse,
  setproctitle,
  sqlalchemy,
  sqlalchemy-jsonfield,
  sqlalchemy-utils,
  structlog,
  svcs,
  tabulate,
  tenacity,
  termcolor,
  universal-pathlib,
  uuid6,
  uvicorn,
  werkzeug,
  pygtrie,
  greenback,
  natsort,

  enabledProviders ? [ ],
}:
let
  version = "3.1.0";

  airflow-src = fetchFromGitHub {
    owner = "apache";
    repo = "airflow";
    tag = "${version}";
    forceFetchGit = true;
    hash = "sha256-w2ulj4aK3fgEGl0UwI1mPeNHgXxDz0Cm79++2KtbLkI=";
  };

  airflowUi = stdenv.mkDerivation {
    pname = "airflow-ui-assets";
    inherit version;
    src = "${airflow-src}/airflow-core/src/airflow/ui";

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      pname = "airflow-ui";
      version = "0.0.0";
      src = "${airflow-src}/airflow-core/src/airflow/ui";
      fetcherVersion = 1;
      hash = "sha256-bGWt9KKvseuwDe7I+GbAUGUz3yGjDA2semKX5EmoNPM=";
    };

    buildPhase = ''
      echo "Building Airflow UI assets..."
      pnpm install
      pnpm build
    '';

    installPhase = ''
      echo "Installing Airflow UI assets..."
      mkdir -p $out/share/airflow/ui
      cp -r dist $out/share/airflow/ui/
    '';
  };

  airflowSimpleAuthUi = stdenv.mkDerivation {
    pname = "airflow-simple-ui-assets";
    inherit version;
    src = "${airflow-src}/airflow-core/src/airflow/api_fastapi/auth/managers/simple/ui";

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      pname = "simple-auth-manager-ui";
      version = "0.0.0";
      src = "${airflow-src}/airflow-core/src/airflow/api_fastapi/auth/managers/simple/ui";
      fetcherVersion = 1;
      hash = "sha256-XXA6Ynxvt/KnVT8EsV4z5Nxd5QejZO8iDDEcS04B57A=";
    };

    buildPhase = ''
      echo "Building Airflow Simple UI assets..."
      pnpm install
      pnpm build
    '';

    installPhase = ''
      echo "Installing Airflow Simple UI assets..."
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
    "fab"
  ];

  providers = import ./providers.nix;
  getProviderPath = provider: lib.replaceStrings [ "_" ] [ "/" ] provider;
  getProviderDeps = provider: map (dep: python.pkgs.${dep}) providers.${provider}.deps;
  getProviderImports = provider: providers.${provider}.imports;
  providerImports = lib.concatMap getProviderImports enabledProviders;

  buildProvider =
    provider:
    buildPythonPackage {
      pname = "apache-airflow-providers-${provider}";
      version = providers.${provider}.version;
      src = "${airflow-src}/providers/${getProviderPath provider}";
      buildInputs = [ flit-core ];
      pyproject = true;
      dependencies = getProviderDeps provider;
      pythonRemoveDeps = [
        "apache-airflow"
      ];
      pythonRelaxDeps = [
        "flit-core"
      ];
    };

  providerPackages = map buildProvider (enabledProviders ++ requiredProviders);

  airflowCore = buildPythonPackage {
    pname = "apache-airflow-core";
    inherit version;
    src = airflow-src;
    preBuild = "cd airflow-core";
    pyproject = true;

    postPatch = ''
      # remove cyclic dependency
      substituteInPlace airflow-core/pyproject.toml \
        --replace-fail '"apache-airflow-task-sdk<1.2.0,>=1.1.0",' ' '

      # Copy built UI assets
      cp -r ${airflowUi}/share/airflow/ui/dist airflow-core/src/airflow/ui/
      cp -r ${airflowSimpleAuthUi}/share/airflow/simple-ui/dist airflow-core/src/airflow/api_fastapi/auth/managers/simple/ui/
    '';

    nativeBuildInputs = [
      airflowUi
      airflowSimpleAuthUi
    ];

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
      taskSdk # subpackage from airflow-src
      a2wsgi
      aiosqlite
      alembic
      argcomplete
      asgiref
      cadwyn
      colorlog
      cron-descriptor
      croniter
      cryptography
      dill
      fastapi
      flask
      gunicorn
      httpx
      itsdangerous
      jinja2
      jsonschema
      lazy-object-proxy
      libcst
      linkify-it-py
      marshmallow-oneofschema
      methodtools
      natsort
      opentelemetry-api
      opentelemetry-exporter-otlp
      pathspec
      pendulum
      pluggy
      psutil
      pydantic
      pygments
      pyjwt
      python-daemon
      python-dateutil
      python-slugify
      requests
      requests-toolbelt
      rfc3339-validator
      rich
      rich-argparse
      setproctitle
      sqlalchemy
      sqlalchemy-jsonfield
      sqlalchemy-utils
      svcs
      tabulate
      tenacity
      termcolor
      universal-pathlib
      uuid6
      uvicorn
      werkzeug
      msgspec
      pygtrie
      structlog
    ]
    ++ providerPackages;
  };

  taskSdk = buildPythonPackage {
    pname = "task-sdk";
    version = "1.0.0";
    src = "${airflow-src}/task-sdk";
    pyproject = true;
    build-system = [
      hatchling
      attrs
    ];

    dependencies = [
      colorlog
      fsspec
      httpx
      jinja2
      methodtools
      msgspec
      pendulum
      psutil
      python-dateutil
      retryhttp
      structlog
      pygtrie
      greenback
    ];

    postPatch = ''
      # resolve cyclic dependency
      substituteInPlace pyproject.toml \
        --replace-fail '"apache-airflow-core<3.2.0,>=3.1.0",' ' '

      # in the upstream code these are softlinks
      # ending outside of the subpackage tree
      # we need to convert them to real directories
      mkdir -p src/airflow/sdk/_shared
      rm src/airflow/sdk/_shared/logging
      rm src/airflow/sdk/_shared/secrets_masker
      rm src/airflow/sdk/_shared/timezones
      cp -r ${airflow-src}/shared/logging/src/airflow_shared/logging src/airflow/sdk/_shared/
      cp -r ${airflow-src}/shared/secrets_masker/src/airflow_shared/secrets_masker src/airflow/sdk/_shared/
      cp -r ${airflow-src}/shared/timezones/src/airflow_shared/timezones src/airflow/sdk/_shared/
    '';
  };

in
buildPythonApplication {
  pname = "apache-airflow";
  inherit version;
  src = airflow-src;
  pyproject = true;

  postInstall = ''
    # Create a symlink to the airflow-core package
    mkdir -p $out/bin
    ln -s ${airflowCore}/bin/airflow $out/bin/airflow
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
    # subpackages from airflow-src
    airflowCore
    taskSdk

    a2wsgi
    alembic
    argcomplete
    asgiref
    attrs
    blinker
    cadwyn
    colorlog
    configupdater
    connexion
    cron-descriptor
    croniter
    cryptography
    deprecated
    dill
    fastapi
    flask
    flask-caching
    flask-session
    flask-wtf
    fsspec
    google-re2
    gunicorn
    httpx
    itsdangerous
    jinja2
    jsonschema
    lazy-object-proxy
    libcst
    linkify-it-py
    lockfile
    markdown-it-py
    markupsafe
    marshmallow-oneofschema
    mdit-py-plugins
    methodtools
    opentelemetry-api
    opentelemetry-exporter-otlp
    pandas
    pendulum
    psutil
    pygments
    pyjwt
    python-daemon
    python-dateutil
    python-nvd3
    python-slugify
    requests
    requests-toolbelt
    rfc3339-validator
    rich
    rich-argparse
    setproctitle
    sqlalchemy
    sqlalchemy-jsonfield
    sqlalchemy-utils
    svcs
    tabulate
    tenacity
    termcolor
    universal-pathlib
    uuid6
    uvicorn
    werkzeug
    natsort
  ]
  ++ providerPackages;

  pythonImportsCheck = [
    "airflow"
  ]
  ++ providerImports;

  installCheckPhase = ''
    export AIRFLOW_HOME=$HOME
    export AIRFLOW__CORE__UNIT_TEST_MODE=True
    export AIRFLOW_DB="$HOME/airflow.db"
    export PATH=$PATH:$out/bin
    airflow version
    airflow db reset -y
  '';

  passthru = {
    updateScript = ./update.sh;
    core = airflowCore;
  };

  meta = with lib; {
    description = "Platform to programmatically author, schedule and monitor workflows";
    homepage = "https://airflow.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ taranarmo ];
    mainProgram = "airflow";
  };
}
