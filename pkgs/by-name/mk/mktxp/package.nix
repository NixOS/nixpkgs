{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:
let
  version = "2.1.0";
in
python3Packages.buildPythonApplication {
  pname = "mktxp";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akpw";
    repo = "mktxp";
    tag = "v${version}";
    hash = "sha256-KHsjOozplUtUj3X54QCZ4pJLDWB11SKwX6KnliBrK80=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    prometheus-client
    routeros-api
    configobj
    humanize
    texttable
    speedtest-cli
    waitress
    packaging
    pyyaml
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "mktxp" ];

  meta = {
    homepage = "https://github.com/akpw/mktxp";
    changelog = "https://github.com/akpw/mktxp/releases/tag/v${version}";
    description = "Prometheus Exporter for Mikrotik RouterOS devices";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.BonusPlay ];
    mainProgram = "mktxp";
  };
}
