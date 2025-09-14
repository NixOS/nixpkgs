{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    rev = "v${version}";
    hash = "sha256-bCE59NeITaCwgajgyXgP6jxtV7aPihPaZ/Uzh39Po1k=";
  };

  strictDeps = true;

  cargoHash = "sha256-KQ4g4hWy8FZH4nLiB0874r8FCINXJboZ4C1dAAPA8Gc=";

  meta = {
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    changelog = "https://github.com/asciinema/agg/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "agg";
  };
}
