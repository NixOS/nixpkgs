{
  lib,
  fetchFromGitHub,
  rustPlatform,
  android-tools,
}:

rustPlatform.buildRustPackage rec {
  pname = "spytrap-adb";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "spytrap-org";
    repo = "spytrap-adb";
    tag = "v${version}";
    hash = "sha256-CL+MxSzHpOq2MXmsaa9sipQZ06Kkzy4r1eFjUrPSj1E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vVDMfst7Uh5q92SYTV9CQdZRoi8ZfjKlqDcQm+YfrjE=";

  env.SPYTRAP_ADB_BINARY = lib.getExe' android-tools "adb";

  meta = {
    description = "Test a phone for stalkerware using adb and usb debugging to scan for suspicious apps and configuration";
    homepage = "https://github.com/spytrap-org/spytrap-adb";
    changelog = "https://github.com/spytrap-org/spytrap-adb/releases/tag/v${version}";
    mainProgram = "spytrap-adb";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ kpcyrd ];
    platforms = lib.platforms.all;
  };
}
