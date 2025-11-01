{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    rev = "v${version}";
    hash = "sha256-6UenPE6mmmvliaIuGdQj/FrlmoJvmBJgfo0hW+uRaxM=";
  };

  strictDeps = true;

  cargoHash = "sha256-VpbjvrMhzS1zrcMNWBjTLda6o3ea2cwpnEDUouwyp8w=";

  meta = with lib; {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "agg";
  };
}
