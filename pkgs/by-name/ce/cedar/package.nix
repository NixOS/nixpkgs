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
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    rev = "refs/tags/v${version}";
    hash = "sha256-p8idQx3HGO/ikL0pDTPXx5+rD2sRpXANqs/g51BL554=";
  };

  cargoHash = "sha256-GuXifjQkH8jV9mT3UYU6rUZB1qO5Xl9tvYJW7MjcW0U=";

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
