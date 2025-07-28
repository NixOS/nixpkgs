{
  lib,
  python3Packages,
  fetchFromGitHub,

  # buildInputs
  buildbox,
  fuse3,
  lzip,
  patch,

  # tests
  addBinToPathHook,
  gitMinimal,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "buildstream";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream";
    tag = version;
    hash = "sha256-6a0VzYO5yj7EHvAb0xa4xZ0dgBKjFcwKv2F4o93oahY=";
  };

  build-system = with python3Packages; [
    cython
    pdm-pep517
    setuptools
    setuptools-scm
  ];

  dependencies = [
    buildbox
  ]
  ++ (with python3Packages; [
    click
    dulwich
    grpcio
    jinja2
    markupsafe
    packaging
    pluginbase
    protobuf
    psutil
    pyroaring
    requests
    ruamel-yaml
    ruamel-yaml-clib
    tomlkit
    ujson
  ]);

  buildInputs = [
    fuse3
    lzip
    patch
  ];

  pythonImportsCheck = [ "buildstream" ];

  nativeCheckInputs = [
    addBinToPathHook
    buildbox
    gitMinimal
    python3Packages.pexpect
    python3Packages.pyftpdlib
    python3Packages.pytest-datafiles
    python3Packages.pytest-env
    python3Packages.pytest-timeout
    python3Packages.pytest-xdist
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  disabledTests = [
    # ValueError: Unexpected comparison between all and ''
    "test_help"

    # Error loading project: project.conf [line 37 column 2]: Failed to load source-mirror plugin 'mirror': No package metadata was found for sample-plugins
    "test_source_mirror_plugin"

    # AssertionError: assert '1a5528cad211...0bbe5ee314c14' == '2ccfee62a657...52dbc47203a88'
    "test_fixed_cas_import"
    "test_random_cas_import"

    # Runtime error: The FUSE stager child process unexpectedly died with exit code 2
    "test_patch_sources_cached_1"
    "test_patch_sources_cached_2"
    "test_source_cache_key"
    "test_custom_transform_source"

    # Blob not found in the local CAS
    "test_source_pull_partial_fallback_fetch"

    # FAILED tests/sources/tar.py::test_out_of_basedir_hardlinks - AssertionError
    "test_out_of_basedir_hardlinks"
  ];

  disabledTestPaths = [
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/source/tmp/popen-gw1/test_report_when_cascache_exit0/buildbox-casd'
    "tests/internals/cascache.py"
  ];

  versionCheckProgram = "${placeholder "out"}/bin/bst";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Powerful software integration tool";
    downloadPage = "https://buildstream.build/install.html";
    homepage = "https://buildstream.build";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "bst";
    maintainers = with lib.maintainers; [ shymega ];
  };
}
