{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "elijah-potter";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-YKfhvwm8TuKpM81qcVgL15AdiQaI7PXvRq1pWThwmo0=";
  };

  cargoHash = "sha256-Gf0GJVWefZlMXpnJytAdmM/I9y7bXoCilUZs/HK0Vdw=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/elijah-potter/harper";
    changelog = "https://github.com/elijah-potter/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
