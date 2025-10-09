{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pfetch-rs";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = "pfetch-rs";
    rev = "v${version}";
    hash = "sha256-Kgoo8piv4pNqzw9zQSEj7POSK6l+0KMvaNbvMp+bpF8=";
  };

  cargoHash = "sha256-36MjBzSzEOVaSnd6dTqYnV+Pi+5EDoUskkYsvYMGrgg=";

  meta = {
    description = "Rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gobidev ];
    mainProgram = "pfetch";
  };
}
