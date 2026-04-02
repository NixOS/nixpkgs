{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mtkclient";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "v${version}";
    hash = "sha256-mbfuOYJvwHfDvjTtAgMBLi7REIRRcJ9bhkY5oVjxCAM=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    colorama
    fusepy
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    shiboken6
  ];

  pythonImportsCheck = [ "mtkclient" ];

  # Note: No need to install mtkclient udev rules, 50-android.rules is covered by
  #       systemd 258 or newer and 51-edl.rules only applies to Qualcomm (i.e. not MTK).

  meta = {
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    mainProgram = "mtk";
    license = lib.licenses.gpl3;
    sourceProvenance = with lib.sourceTypes; [
      # loaders, preloaders and exploit payloads
      binaryFirmware
      # everything else
      fromSource
    ];
    maintainers = [ lib.maintainers.timschumi ];
  };
}
