{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    rev = "v${version}";
    hash = "sha256-FjAf/rhyxsm4LHoko4QRA9t5e+qKIgO2kSd48Zmf224=";
  };

  strictDeps = true;

  cargoHash = "sha256-CeXcpSD/6qPzA8nrSyC3oDFBpjFYNfDPySQxSOZPlgc=";

  meta = with lib; {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "agg";
  };
}
