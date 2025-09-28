{
  lib,
  flutter335,
  fetchFromGitHub,
}:

flutter335.buildFlutterApplication rec {
  pname = "firmware-updater";
  version = "0-unstable-2025-09-09";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/apps/firmware_updater";

  gitHashes = {
    fwupd = "sha256-l/+HrrJk1mE2Mrau+NmoQ7bu9qhHU6wX68+m++9Hjd4=";
  };

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "402e97254b9d63c8d962c46724995e377ff922c8";
    hash = "sha256-nQn5mlgNj157h++67+mhez/F1ALz4yY+bxiGsi0/xX8=";
  };

  meta = with lib; {
    description = "Firmware Updater for Linux";
    mainProgram = "firmware-updater";
    homepage = "https://github.com/canonical/firmware-updater";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
