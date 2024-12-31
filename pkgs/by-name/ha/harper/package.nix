{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "elijah-potter";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-X1mTqaqOqeAM7mq3nNrE2ULZ1zaAxZIqp0p1wdlDwgk=";
  };

  cargoHash = "sha256-0RJ0Kpht4gqZTBdjld1Wi5r9FN5RB74KboxODmlHoko=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/elijah-potter/harper";
    changelog = "https://github.com/elijah-potter/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
