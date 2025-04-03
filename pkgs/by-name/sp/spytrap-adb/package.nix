{
  lib,
  fetchFromGitHub,
  rustPlatform,
  android-tools,
}:

rustPlatform.buildRustPackage rec {
  pname = "spytrap-adb";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "spytrap-org";
    repo = "spytrap-adb";
    tag = "v${version}";
    hash = "sha256-Yqa+JmqYCmy9ehxmRebPNlU5U2RPHtnHDHiqSg8EvAo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hXDxo0b2nJbPyo99Qc39LM0P41SDbyfadHLIRrbQdj0=";

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
