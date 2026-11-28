{
  lib,
  python3Packages,
  fetchFromGitLab,
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

  # lark-parser is the old PyPI name for what's now published as `lark`;
  # both provide the same `lark` module, but the wheel metadata still
  # requires the old name.
  pythonRemoveDeps = [ "lark-parser" ];

  dependencies = [
    bubblewrap
    buildbox
    fuse3
    openssl
    postgresql
    wget
  ]
  ++ (with python3Packages; [
    alembic
    boto3
    botocore
    buildgrid-metering-client
    click
    cryptography
    dnspython
    grpcio
    grpcio-health-checking
    grpcio-reflection
    janus
    jinja2
    jsonschema
    lark
    mmh3
    protobuf
    pycurl
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
    homepage = "https://buildgrid.build/";
    license = lib.licenses.asl20;
    mainProgram = "bgd";
    maintainers = with lib.maintainers; [ shymega ];
    platforms = lib.platforms.linux;
  };
})
