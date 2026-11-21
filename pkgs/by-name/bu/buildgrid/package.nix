{
  lib,
  python3Packages,
  fetchFromGitLab,
  fetchFromGitHub,
  fetchPypi,
  nix-update-script,

  # buildInputs
  buildbox,
  fuse3,
  bubblewrap,
  postgresql,
  wget,
  openssl,

  # tests
  addBinToPathHook,
  gitMinimal,
  versionCheckHook,
}:
let
  pycurl = python3Packages.pycurl.overrideAttrs (oldAttrs: rec {
    version = "7.46.0";
    src = fetchFromGitHub {
      owner = "pycurl";
      repo = "pycurl";
      tag = "REL_${lib.replaceStrings [ "." ] [ "_" ] version}";
      hash = "sha256-F40bJ7TYFK2dVkDJGGxl7XV46fKmjwvUYYulcwGL6hk=";
    };
    patches = [ ];

    doCheck = false;
    doInstallCheck = false;
  });
  buildgrid-metering-client = python3Packages.buildPythonApplication (finalAttrs: {
    pname = "buildgrid-metering-client";
    version = "0.0.4";
    format = "pyproject";

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-mA1nBIYZ8i/zaJzEe3ZVRcdxgy84HvmIczA0Tpsl06c=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = with python3Packages; [
      pydantic
      aiohttp
      async-lru
      tenacity
      cachetools
      requests
    ];
  });
  lark-parser = python3Packages.lark.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "lark-parser";
      version = "0.12.0";
      format = "pyproject";

      src = fetchPypi {
        inherit (finalAttrs) pname version;
        hash = "sha256-FZZ9sfEhQBPcplsRgHRQR7m+RX1z2iJPzaPZ3U6WoTg=";
      };

      build-system = with python3Packages; [
        setuptools
        setuptools-scm
      ];

      # Optional import, but fixes some re known bugs & allows advanced regex features
      dependencies = with python3Packages; [
        regex
      ];
    }
  );
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "buildgrid";
  version = "0.8.11";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitLab {
    owner = "BuildGrid";
    repo = "buildgrid";
    tag = finalAttrs.version;
    hash = "sha256-54L+CZO94GMm20BoOnFhGQt244mMIPa8XjmWjmrHiz4=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = [
    bubblewrap
    buildbox
    buildgrid-metering-client
    fuse3
    lark-parser
    openssl
    postgresql
    pycurl
    wget
  ]
  ++ (with python3Packages; [
    alembic
    boto3
    botocore
    click
    cryptography
    dnspython
    grpcio
    grpcio-health-checking
    grpcio-reflection
    janus
    jinja2
    jsonschema
    mmh3
    protobuf
    pydantic
    pyjwt
    pyyaml
    requests
    sentry-sdk
    sqlalchemy
  ]);

  pythonImportsCheck = [ "buildgrid" ];

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
  ]
  ++ (with python3Packages; [
    flaky
    pytest-datafiles
    pytest-env
    pytest-forked
    pytest-postgresql
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ]);

  checkInputs = with python3Packages; [
    fakeredis
    flask
    flask-cors
    jwcrypto
    psutil
    psycopg
    psycopg2
    pyopenssl
  ];

  # Upstream's pyproject.toml addopts enable pycodestyle-as-test and coverage
  # reporting, neither of which are relevant here.
  pytestFlags = [
    "-o"
    "addopts="
  ];

  disabledTestPaths = [
    # Not a test module, but matched by upstream's `python_files = "tests/*.py"`.
    "tests/action_cache.py"
    # These all require a `moto_server` instance already running, which
    # nixpkgs' test sandbox doesn't provide.
    "tests/cas/test_storage.py"
    "tests/cas/test_s3_janitor.py"
    "tests/cas/test_s3_deletes.py"
    "tests/integration/test_cleanup.py"
  ];

  disabledTests = [
    # Compares a path against the wrong base directory, producing a path
    # outside the test's own temp dir; an upstream test bug independent of packaging.
    "test_download_file"
    "test_download_file_failure"
  ];

  doCheck = true;
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A remote execution service, implementing Google's REAPI and RWAPI.";
    homepage = "https://gitlab.com/BuildGrid/buildgrid";
    license = lib.licenses.asl20;
    mainProgram = "bgd";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
  };
})
