{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,

  # buildInputs
  buildbox,
  fuse3,
  lzip,
  patch,

  # tests
  addBinToPathHook,
  gitMinimal,
  versionCheckHook,

  # Optional features
  enableBuildstreamPlugins ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "buildstream";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream";
    tag = version;
    hash = "sha256-/kGmAHx10//iVeqLXwcIWNI9FGIi0LlNJW+s6v0yU3Q=";
  };

  # FIXME: To be removed in v2.6.0 of Buildstream.
  patches = [
    (fetchpatch {
      url = "https://github.com/apache/buildstream/commit/9c4378ab2ec71b6b79ef90ee4bd950dd709a0310.patch?full_index=1";
      hash = "sha256-po3Dn7gCv7o7h3k8qhmoH/b6Vv6ikKO/pkA20RvdU1g=";
    })
    (fetchpatch {
      url = "https://github.com/apache/buildstream/commit/456a464b2581c52cad2b0b48596f5c19ad1db23f.patch?full_index=1";
      hash = "sha256-0oFENx4AUhd1uJxRzbKzO5acGDosCc4vFJaSJ6urvhk=";
    })
  ];

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
  ])
  ++ lib.optionals enableBuildstreamPlugins [
    python3Packages.buildstream-plugins
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
    # FIXME: To be removed in v2.6.0 of Buildstream.
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
