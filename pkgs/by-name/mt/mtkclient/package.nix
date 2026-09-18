{
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  gcc-arm-embedded,
  makeDesktopItem,
  python3Packages,
  udevCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mtkclient";
  version = "2.1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "v${version}";
    hash = "sha256-8Y9tyw+dmhhc4tFo3slr4wQIPXIrmIk/wuCK4aM6oLY=";
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

  nativeBuildInputs = [
    udevCheckHook
    copyDesktopItems

    # Dependencies for stage1 kamakiri payloads
    gcc-arm-embedded
  ];

  pythonImportsCheck = [ "mtkclient" ];

  # Build on-device payloads from source before assembling into a python package.
  preBuild = ''
    make -C src/stage1
  '';

  # Note: No need to install other mtkclient udev rules, 50-android.rules is covered by
  #       systemd 258 or newer and 51-edl.rules only applies to Qualcomm (i.e. not MTK).
  postInstall = ''
    install -Dm444 Setup/Linux/52-mtk.rules -t $out/lib/udev/rules.d
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mtkclient";
      desktopName = "MTKClient";
      comment = "Mediatek Flash and Repair Utility";
      exec = "mtk_gui";
      categories = [
        "Development"
      ];
    })
  ];

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
