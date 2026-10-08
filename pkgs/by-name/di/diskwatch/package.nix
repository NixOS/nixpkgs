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
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "diskwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQZLJsxKTgSXmn+vu/AGQfMX0z2CJ2T50B/EmxKaa0E=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-fjyRUVF7P/vlNAR7P8sVSyt23jV3kKMFPvSVOWWcBuc=";

  nativeCheckInputs = [ versionCheckHook ];

  buildInputs = lib.optionals withSmartmontools [ smartmontools ];

  doInstallCheck = true;

  cargoTestFlags = [
    "--"
    "--skip=left_right_cycle_all_tabs_without_moving_selections"
  ];

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
