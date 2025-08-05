{
  lib,
  fetchFromGitHub,
  rustPlatform,
  android-tools,
}:

rustPlatform.buildRustPackage rec {
  pname = "spytrap-adb";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "spytrap-org";
    repo = "spytrap-adb";
    tag = "v${version}";
    hash = "sha256-t5MNgsuH5FVEjUP9FFxbjXs5BVim0ZyfNKUTQOjKpqg=";
  };

  cargoHash = "sha256-VoUzAHTxJLeyi60ftuOkI6PAuLUsSsQSUjk9rcGz86A=";

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
