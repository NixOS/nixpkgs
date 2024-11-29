{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  usage,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "jdx";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-9zQ+gkBVhzjqSIieGjxoD9vc7999lfRQ7awkvlEkseE=";
  };

  cargoHash = "sha256-4ebjD1Tf7F2YyNrF7eEi2yKonctprnyu4nMf+vE2whY=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = usage; };
  };

  meta = {
    homepage = "https://usage.jdx.dev";
    description = "Specification for CLIs";
    changelog = "https://github.com/jdx/usage/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "usage";
  };
}
