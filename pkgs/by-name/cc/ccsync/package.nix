{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccsync";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "onsails";
    repo = "ccsync";
    tag = "ccsync-v${finalAttrs.version}";
    hash = "sha256-+Bcm7j5Z7KG1rvHF/oysci1WM7uvw8mDXcNhP4mtQBU=";
  };

  cargoHash = "sha256-/wL3/Cs4Z23TVqGtcnP3u2j0k4bwUntN9nrtAZDvCig=";

  meta = {
    description = "Sync your Claude Code agents, skills, and commands between global and project configurations";
    homepage = "https://github.com/onsails/ccsync";
    changelog = "https://github.com/onsails/ccsync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ccsync";
    maintainers = with lib.maintainers; [ onsails ];
  };
})
