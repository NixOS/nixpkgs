{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
  kickstart,
}:

rustPlatform.buildRustPackage rec {
  pname = "kickstart";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "kickstart";
    rev = "v${version}";
    hash = "sha256-4POxv6fIrp+wKb9V+6Y2YPx3FXp3hpnkq+62H9TwGII=";
  };

  cargoHash = "sha256-J9sGXJbGbO9UgZfgqxqzbiJz9j6WMpq3qC2ys7OJnII=";

  buildFeatures = [ "cli" ];

  checkFlags = [
    # remote access
    "--skip=generation::tests::can_generate_from_remote_repo_with_subdir"
    "--skip=generation::tests::can_generate_from_remote_repo"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = kickstart;
    };
  };

  meta = {
    description = "Scaffolding tool to get new projects up and running quickly";
    homepage = "https://github.com/Keats/kickstart";
    changelog = "https://github.com/Keats/kickstart/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "kickstart";
  };
}
