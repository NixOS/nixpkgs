{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  # Renaming it to amber-secret because another package named amber exists
  pname = "amber-secret";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "amber";
    tag = "v${version}";
    hash = "sha256-nduSnDhLvHpZD7Y1zeZC4nNL7P1qfLWc0yMpsdqrKHM=";
  };

  cargoHash = "sha256-Gwj0rnbKWifja5NJwskcrFpPoK15HjSQHXolGbgV784=";

  meta = {
    description = "Manage secret values in-repo via public key cryptography";
    homepage = "https://github.com/fpco/amber";
    changelog = "https://github.com/fpco/amber/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "amber";
  };
}
