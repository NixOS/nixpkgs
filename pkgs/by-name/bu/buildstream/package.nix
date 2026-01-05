{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,

  # buildInputs
  buildbox,
  fuse3,
  lzip,
  patch,

  # nativeBuildInputs
  installShellFiles,

  # tests
  addBinToPathHook,
  gitMinimal,
  versionCheckHook,

  # Optional features
  enableBuildstreamPlugins ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "buildstream";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream";
    tag = version;
    hash = "sha256-2Z+s0dQB85MBO06llhIEO3jwWfL53n74S28ENHcbe/Q=";
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
    grpcio
    jinja2
    markupsafe
    packaging
    pluginbase
    protobuf
    psutil
    pyroaring
    ruamel-yaml
    ruamel-yaml-clib
    ujson
  ])
  ++ lib.optionals enableBuildstreamPlugins [
    python3Packages.buildstream-plugins
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

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
  ];

  disabledTestPaths = [
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/source/tmp/popen-gw1/test_report_when_cascache_exit0/buildbox-casd'
    "tests/internals/cascache.py"
  ];

  postInstall = ''
    installShellCompletion --cmd bst \
      --bash src/buildstream/data/bst \
      --zsh src/buildstream/data/zsh/_bst
  '';

  versionCheckProgram = "${placeholder "out"}/bin/bst";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

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
