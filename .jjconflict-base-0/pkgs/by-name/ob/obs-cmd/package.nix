{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-lVcg7jSA8W2m98DgDEQJWetfNYvp/JYbRuo8jCsLLZs=";
  };

  cargoHash = "sha256-+uFLaN02iSQLdUAUh4qmUyfIrrMi1nnaNh3sR+N8KbU=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "obs-cmd";
  };
}
