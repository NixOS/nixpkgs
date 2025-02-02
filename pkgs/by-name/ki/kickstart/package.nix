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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Keats";
    repo = "kickstart";
    rev = "v${version}";
    hash = "sha256-GIBSHPIUq+skTx5k+94/K1FJ30BCboWPA6GadgXwp+I=";
  };

  cargoHash = "sha256-cOcldEte7zxyxzvj7v7uCczs5AQ+v4mMfqmTK9hrv1o=";

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

  meta = with lib; {
    description = "Scaffolding tool to get new projects up and running quickly";
    homepage = "https://github.com/Keats/kickstart";
    changelog = "https://github.com/Keats/kickstart/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "kickstart";
  };
}
