{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  version = "1.2.20";
in
python3Packages.buildPythonApplication {
  pname = "mktxp";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akpw";
    repo = "mktxp";
    tag = "v${version}";
    hash = "sha256-xYVIaO60ih3P/oV11QljSCF5iRYf2fK3EjEhhdPFIzo=";
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
  ];

  # tests create the mktxp config under $HOME
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

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
