{
  lib,
  python3Packages,
  fetchPypi,
  nixosTests,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "prefect";
  version = "3.4.22";
  pyproject = true;

  # Trying to install from source is challenging
  # the packaging is using versioningit and looking for
  # .git directory
  # Source will be missing sdist, uv.lock, ui artefacts ...
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S0ank+mQekyFObBLsv28YJyYEPaQ12c6O8jQya69/IQ=";
  };

  pythonRelaxDeps = [
    "websockets"
  ];

  build-system = with python3Packages; [
    hatchling
    versioningit
  ];

  dependencies =
    with python3Packages;
    [
      aiosqlite
      alembic
      apprise
      asyncpg
      click
      cryptography
      dateparser
      docker
      graphviz
      jinja2
      jinja2-humanize-extension
      humanize
      pytz
      readchar
      sqlalchemy
      typer
      # client dependencies
      anyio
      asgi-lifespan
      cachetools
      cloudpickle
      coolname
      exceptiongroup
      fastapi
      fsspec
      # graphviz already included
      griffe
      httpcore
      httpx
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
      pyyaml
      rfc3339-validator
      rich
      ruamel-yaml
      semver
      sniffio
      toml
      typing-extensions
      ujson
      uvicorn
      websockets
      whenever
      uv
    ]
    ++ sqlalchemy.optional-dependencies.asyncio
    ++ httpx.optional-dependencies.http2
    ++ python-socks.optional-dependencies.asyncio;

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

    updateScript = nix-update-script {
      extraArgs = [
        # avoid pre‐releases
        "--version-regex"
        "^(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
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
    description = "Workflow orchestration framework for building resilient data pipelines in Python";
    homepage = "https://github.com/PrefectHQ/prefect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "prefect";
  };
}
