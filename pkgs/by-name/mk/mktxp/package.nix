{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  version = "1.2.11";
in
python3Packages.buildPythonApplication {
  pname = "mktxp";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "akpw";
    repo = "mktxp";
    tag = "v${version}";
    hash = "sha256-XF9JbN/k3yUigwmOS4/JHl/hkln71lOD4qMfRbFiAF0=";
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
    pyyaml
  ];

  meta = {
    homepage = "https://github.com/akpw/mktxp";
    changelog = "https://github.com/akpw/mktxp/releases/tag/v${version}";
    description = "Prometheus Exporter for Mikrotik RouterOS devices";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      BonusPlay
      tsandrini
    ];
    mainProgram = "mktxp";
  };
}
