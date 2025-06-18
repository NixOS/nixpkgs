{
  lib,
  cedar,
  testers,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cedar";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${version}";
    hash = "sha256-9lR1k8XoQDAbaknAGg5kFENX5cJY4l6JgGNyl1dbUXM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XFQo7/NRgRcxhzgdiXJ4iINU22s58Vp/kHLt7Jdr5/s=";

  passthru = {
    tests.version = testers.testVersion { package = cedar; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Implementation of the Cedar Policy Language";
    homepage = "https://github.com/cedar-policy/cedar";
    changelog = "https://github.com/cedar-policy/cedar/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "cedar";
  };
}
