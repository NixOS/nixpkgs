{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
  runtimeShell,

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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "buildstream";
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream";
    tag = finalAttrs.version;
    hash = "sha256-i46AdbGk/xGZeyh6bxQd1J3L3EH/oIcjX9cJSDscfH0=";
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

  # The dummy buildbox-casd scripts spawned by tests/internals/cascache.py use
  # an `/usr/bin/env sh` shebang, which doesn't exist in the Nix build sandbox.
  postPatch = ''
    substituteInPlace tests/internals/cascache.py \
      --replace-fail '#!/usr/bin/env sh' '#!${runtimeShell}'
  '';

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

    # Runtime error: The FUSE stager child process unexpectedly died with exit code 2
    "test_patch_sources_cached_1"
    "test_patch_sources_cached_2"
    "test_source_cache_key"
    "test_custom_transform_source"
  ];

  postInstall = ''
    installShellCompletion --cmd bst \
      --bash src/buildstream/data/bst \
      --zsh src/buildstream/data/zsh/_bst
  '';

  versionCheckProgram = "${placeholder "out"}/bin/bst";

  passthru.updateScript = gitUpdater {
    ignoredVersions = "dev";
  };

  meta = {
    changelog = "https://github.com/apache/buildstream/blob/${finalAttrs.src.tag}/NEWS";
    description = "Powerful software integration tool";
    downloadPage = "https://buildstream.build/install.html";
    homepage = "https://buildstream.build";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "bst";
    maintainers = with lib.maintainers; [ shymega ];
  };
})
