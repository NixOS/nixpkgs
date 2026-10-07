{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,

  # buildInputs
  buildbox,
  fuse3,
  lzip,
  patch,

  # nativeBuildInputs
  installShellFiles,

  # tests
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

  # /dev/fuse is not available inside the Nix build sandbox, so buildbox-casd's
  # default FUSE-based staging strategy cannot work here, and the shebang used
  # by tests/internals/cascache.py's dummy buildbox-casd scripts
  # (`/usr/bin/env sh`) doesn't exist there either. The pytest suite is run as
  # a NixOS VM test instead, where both of those are available; see
  # `passthru.tests.pytest`.
  pythonImportsCheck = [ "buildstream" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  postInstall = ''
    installShellCompletion --cmd bst \
      --bash src/buildstream/data/bst \
      --zsh src/buildstream/data/zsh/_bst
  '';

  versionCheckProgram = "${placeholder "out"}/bin/bst";

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "dev";
    };

    tests.pytest = nixosTests.buildstream;
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
