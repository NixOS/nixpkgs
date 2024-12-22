{
  lib,
  writeText,
  flutter,
  fetchFromGitHub,
}:

flutter.buildFlutterApplication rec {
  pname = "firmware-updater";
  version = "0-unstable-2024-20-11";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "./source/apps/firmware_updater";

  gitHashes = {
    fwupd = "sha256-l/+HrrJk1mE2Mrau+NmoQ7bu9qhHU6wX68+m++9Hjd4=";
  };

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "ab5d44d594d68d106aafb511252a94a24e94d601";
    hash = "sha256-4a0OojgNvOpvM4+8uSslxxKb6uwKDfDkvHo29rMXynQ=";
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
