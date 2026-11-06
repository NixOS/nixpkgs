{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

let
  # `lean.models` loads its catalogue of brokerages, data providers and plugins
  # at import time and refreshes it from the CDN once a day. The package ships
  # this snapshot as the offline fallback; the file name is the one the CLI
  # expects.
  modules-json = fetchurl {
    url = "https://cdn.quantconnect.com/cli/modules-1.14.json";
    hash = "sha256-hGzc7aee/Ui0UstBLi415KtTW/XYTMYxK5QUKKWlR94=";
  };
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lean-cli";
  version = "1.0.233";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "QuantConnect";
    repo = "lean-cli";
    tag = finalAttrs.version;
    hash = "sha256-vZ4PWH3v5Vw2wRxvemt2cNSYbX8kWwg5PP2ri1dNI6k=";
  };

  build-system = [ python3Packages.setuptools ];

  patches = [ ./modules-json-cache.patch ];

  postPatch = ''
    cp ${modules-json} lean/modules-1.14.json

    # The repository keeps the version at 0.0.0-dev and the release workflow
    # rewrites it, so set it here.
    substituteInPlace lean/__init__.py \
      --replace-fail '__version__ = "0.0.0-dev"' '__version__ = "${finalAttrs.version}"'
  '';

  # `setup.py` asks PyPI for the newest quantconnect-stubs release unless this is
  # a dev build. The lookup is wrapped in a bare `except`, so it degrades to an
  # unversioned requirement in the sandbox; the version is pinned through
  # `dependencies` instead.
  dependencies = with python3Packages; [
    click
    cryptography
    docker
    joblib
    json5
    lxml
    packaging
    plotext_6
    pydantic
    python-dateutil
    quantconnect-stubs
    requests
    rich
    textual
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pyfakefs
    pytest-asyncio
    pytestCheckHook
    responses
  ]);

  # The upstream suite relies on asyncio auto mode.
  pytestFlags = [
    "-o"
    "asyncio_mode=auto"
  ];

  # The test expects an empty HOME, but an earlier test in the same session has
  # already created ~/.lean/config.
  disabledTests = [
    "test_lean_command_fails_when_lean_config_not_available"
    # A test helper that is collected as a test and returns a mock, which
    # pytest-asyncio's auto mode rejects.
    "test_get_logger"
  ];

  postInstall = ''
    install -Dm644 ${modules-json} $out/${python3Packages.python.sitePackages}/lean/modules-1.14.json
  '';

  pythonImportsCheck = [ "lean" ];

  meta = {
    description = "CLI for running the LEAN engine locally and in the cloud";
    homepage = "https://github.com/QuantConnect/lean-cli";
    changelog = "https://github.com/QuantConnect/lean-cli/releases";
    license = lib.licenses.asl20;
    mainProgram = "lean";
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
