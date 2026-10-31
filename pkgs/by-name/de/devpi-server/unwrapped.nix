{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  versionCheckHook,

  # build-system
  setuptools_80,

  # dependencies
  aiohttp,
  appdirs,
  defusedxml,
  devpi-common,
  execnet,
  httpx,
  itsdangerous,
  packaging,
  packaging-legacy,
  passlib,
  platformdirs,
  pluggy,
  py,
  pyramid,
  repoze-lru,
  strictyaml,
  waitress,

  # tests
  beautifulsoup4,
  nginx,
  pytest-asyncio,
  pytestCheckHook,
  webtest,

  # passthru
  devpi-server,
  gitUpdater,
  nixosTests,
  testers,
}:

buildPythonPackage (finalAttrs: {
  pname = "devpi-server";
  version = "6.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    tag = "server-${finalAttrs.version}";
    hash = "sha256-QDs3Ue4F5NzkqvB44R9PXctcMh1+2+CNING1l4yG2MU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_changelog_shortener",' ""
  '';

  pythonRelaxDeps = [ "cryptography" ];

  sourceRoot = "${finalAttrs.src.name}/server";

  dependencies = [
    aiohttp
    appdirs
    defusedxml
    devpi-common
    execnet
    httpx
    itsdangerous
    packaging
    packaging-legacy
    passlib
    platformdirs
    pluggy
    py
    pyramid
    repoze-lru
    setuptools_80
    strictyaml
    waitress
  ]
  ++ passlib.optional-dependencies.argon2;

  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeCheckInputs = [
    beautifulsoup4
    nginx
    pytest-asyncio
    pytestCheckHook
    webtest
  ];

  # root_passwd_hash tries to write to store
  # TestMirrorIndexThings tries to write to /var through nginx
  # nginx tests try to write to /var
  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$TMPDIR
  '';

  pytestFlags = [
    "-rfsxX"
  ];

  enabledTestPaths = [
    "./test_devpi_server"
  ];

  disabledTestPaths = [
    "test_devpi_server/test_nginx_replica.py"
    "test_devpi_server/test_streaming_nginx.py"
    "test_devpi_server/test_streaming_replica_nginx.py"
  ];

  disabledTests = [
    "test_fetch_later_deleted" # incompatible with newer pytest
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "devpi_server" ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    tests = {
      devpi-server = nixosTests.devpi-server;
      version = testers.testVersion {
        package = devpi-server;
      };
    };
    # devpi uses a monorepo for server, common, client and web
    updateScript = gitUpdater {
      rev-prefix = "server-";
    };
  };

  meta = {
    homepage = "http://doc.devpi.net";
    changelog = "https://github.com/devpi/devpi/blob/${finalAttrs.src.tag}/server/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      confus
      makefu
    ];
    mainProgram = "devpi-server";
  };
})
