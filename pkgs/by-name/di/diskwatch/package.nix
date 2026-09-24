{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,

  # full SMART attribute tables. Else, fallback to basic verified/failing flag from diskutil
  withSmartmontools ? false,
  smartmontools,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diskwatch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "diskwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pKo4zXyoX2OiOIwirCdzQuuFW1dMye/AA4MNVYgki3A=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-Nr01CMCsh3llYAlVS0O0F+/rmopTywxw9itISYoyQRI=";

  nativeCheckInputs = [ versionCheckHook ];

  buildInputs = lib.optionals withSmartmontools [ smartmontools ];

  doInstallCheck = true;

  meta = {
    description = "Single-host, read-only disk diagnostics TUI";
    homepage = "https://www.netwatchlabs.com/labs/diskwatch";
    changelog = "https://github.com/matthart1983/diskwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      tomasrivera
    ];
    mainProgram = "diskwatch";
  };
})
