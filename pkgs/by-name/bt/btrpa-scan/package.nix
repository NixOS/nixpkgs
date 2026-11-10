{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "btrpa-scan";
  version = "0.6.0-unstable-2026-02-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HackingDave";
    repo = "btrpa-scan";
    rev = "aa286d8d7a5ff11926f1b9f064ec9e00eeeeb5a6";
    hash = "sha256-Q0+seEDvBQ2s+f8djM71JV84yzODe+gBEZZV1UTKKGg=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    bleak
    cryptography
    flask
    flask-socketio
  ];

  pythonImportsCheck = [ "btrpa_scan" ];

  meta = {
    description = "Bluetooth Low Energy (BLE) scanner";
    homepage = "https://github.com/HackingDave/btrpa-scan";
    changelog = "https://github.com/HackingDave/btrpa-scan/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "btrpa-scan";
  };
})
