{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ccsync";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "onsails";
    repo = "ccsync";
    tag = "ccsync-v${version}";
    hash = "sha256-FHOQgZLtXSN6nHN401JimEOSCViMG7nAmePV6a7GBa8=";
  };

  cargoHash = "sha256-E/56tCVYydyB7WaCpWBDzzv0sGWez3JmWKAMa/Zfqp0=";

  meta = {
    description = "Sync your Claude Code agents, skills, and commands between global and project configurations";
    homepage = "https://github.com/onsails/ccsync";
    changelog = "https://github.com/onsails/ccsync/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ccsync";
    maintainers = with lib.maintainers; [ onsails ];
  };
}
