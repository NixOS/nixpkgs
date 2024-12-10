{
  lib,
  writeText,
  flutter,
  fetchFromGitHub,
}:

flutter.buildFlutterApplication rec {
  pname = "firmware-updater";
  version = "0-unstable-2024-10-03";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "./source/packages/firmware_updater";

  gitHashes = {
    fwupd = "sha256-l/+HrrJk1mE2Mrau+NmoQ7bu9qhHU6wX68+m++9Hjd4=";
  };

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "ce300838d95c5955423eedcac8b05589b14a8c52";
    hash = "sha256-o3OU43pEzo8FC5e6kknB8BV9n7U4RMqg/+CDbHraAKw=";
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
