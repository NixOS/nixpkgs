{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "backdown";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "backdown";
    rev = "v${version}";
    hash = "sha256-3+XmMRZz3SHF1sL+/CUvu4uQ2scE4ACpcC0r4nWhdkM=";
  };

  cargoHash = "sha256-qVE4MOFr0YO+9rAbfnz92h0KocaLu+v2u5ompwY/o6k=";

  meta = with lib; {
    description = "File deduplicator";
    homepage = "https://github.com/Canop/backdown";
    changelog = "https://github.com/Canop/backdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "backdown";
  };
}
