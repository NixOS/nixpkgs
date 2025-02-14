{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "feluda";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "anistark";
    repo = "feluda";
    tag = version;
    hash = "sha256-137411bde1ae404d4342ef2225ec885ca04f868f";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "Detect license usage restrictions in your project! ";
    homepage = "https://github.com/anistark/feluda";
    changelog = "https://github.com/anistark/feluda/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ transgirl_lucy ];
    mainProgram = "feluda";
  };
}
