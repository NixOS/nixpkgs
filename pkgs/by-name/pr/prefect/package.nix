{
  lib,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "prefect";
  version = "3.2.7";
  pyproject = true;

  # Trying to install from source is challenging
  # the packaging is using versioningit and looking for
  # .git directory
  # Source will be missing sdist, uv.lock, ui artefacts ...
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4kwGrKvDihBi6Gcvcf6ophNI6GGd+M4qR0nnu/AUK1Q=";
  };

  patches = [
    ./make_ui_files_writeable_on_startup.patch
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  build-system = with python3Packages; [
    hatchling
    versioningit
  ];

  dependencies = with python3Packages; [
    aiosqlite
    alembic
    anyio
    apprise
    asgi-lifespan
    asyncpg
    cachetools
    click
    cloudpickle
    coolname
    cryptography
    dateparser
    docker
    exceptiongroup
    fastapi
    fsspec
    graphviz
    griffe
    httpcore
    httpx
    humanize
    importlib-metadata
    jinja2
    jinja2-humanize-extension
    jsonpatch
    jsonschema
    opentelemetry-api
    orjson
    packaging
    pathspec
    pendulum
    prometheus-client
    pydantic
    pydantic-core
    pydantic-extra-types
    pydantic-settings
    python-dateutil
    python-slugify
    python-socks
    pytz
    pyyaml
    readchar
    rfc3339-validator
    rich
    ruamel-yaml
    sniffio
    sqlalchemy
    toml
    typer
    typing-extensions
    ujson
    uvicorn
    websockets
  ];

  optional-dependencies = with python3Packages; {
    aws = [
      # prefect-aws
    ];
    azure = [
      # prefect-azure
    ];
    bitbucket = [
      # prefect-bitbucket
    ];
    dask = [
      # prefect-dask
    ];
    databricks = [
      # prefect-databricks
    ];
    dbt = [
      # prefect-dbt
    ];
    docker = [
      # prefect-docker
    ];
    email = [
      # prefect-email
    ];
    gcp = [
      # prefect-gcp
    ];
    github = [
      # prefect-github
    ];
    gitlab = [
      # prefect-gitlab
    ];
    kubernetes = [
      # prefect-kubernetes
    ];
    otel = [
      opentelemetry-distro
      opentelemetry-exporter-otlp
      opentelemetry-instrumentation
      opentelemetry-instrumentation-logging
      opentelemetry-test-utils
    ];
    ray = [
      # prefect-ray
    ];
    redis = [
      # prefect-redis
    ];
    shell = [
      # prefect-shell
    ];
    slack = [
      # prefect-slack
    ];
    snowflake = [
      # prefect-snowflake
    ];
    sqlalchemy = [
      # prefect-sqlalchemy
    ];
  };

  makeWrapperArgs = [
    # Add the installed directories to the python path so the worker can find them
    "--prefix PYTHONPATH : ${python3Packages.makePythonPath dependencies}"
    "--prefix PYTHONPATH : $out/${python3Packages.python.sitePackages}"
  ];

  passthru.tests = {
    inherit (nixosTests) prefect;
  };

  # Tests are not included in the pypi source
  doCheck = false;
  # nativeCheckInputs = (
  #   with python3Packages;
  #   [
  #     pytestCheckHook
  #     pytest-asyncio
  #     pytest-cov
  #     pytest-env
  #     # pytest-flakefinder
  #     pytest-mypy-plugins
  #     pytest-timeout
  #     pytest-xdist
  #   ]
  # );

  meta = {
    description = "Prefect is a workflow orchestration framework for building resilient data pipelines in Python";
    homepage = "https://github.com/PrefectHQ/prefect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "prefect";
  };
}
