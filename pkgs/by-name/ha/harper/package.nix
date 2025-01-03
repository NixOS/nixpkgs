{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "elijah-potter";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-DpBCTljIigpyZdiFm8x/bqDn+kzK8ILHpzGqX0d1mI8=";
  };

  cargoHash = "sha256-ZMZq/HRvr+JO/fHBJcyRtKXSzCabxkJRBe6OQjij77g=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/elijah-potter/harper";
    changelog = "https://github.com/elijah-potter/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
