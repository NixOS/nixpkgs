{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  version = "1.2.12";
in
python3Packages.buildPythonApplication {
  pname = "mktxp";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "akpw";
    repo = "mktxp";
    tag = "v${version}";
    hash = "sha256-2aSRnfhOROFJWzqvltYaN2FLXrRjICV56SOOHf4wKtg=";
  };

  nativeBuildInputs = with python3Packages; [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  dependencies = with python3Packages; [
    prometheus-client
    routeros-api
    configobj
    humanize
    texttable
    speedtest-cli
    waitress
    packaging
  ];

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
