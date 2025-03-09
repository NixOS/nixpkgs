{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
    hash = "sha256-3q0q9Bj/DPuDmHu2G9jrABFXU8xgbUUS7iTBguVWR5s=";
  };

  cargoHash = "sha256-bh72u1AvM6bGNQCjyu6GdAiK0jw5lE0SIdYzaZEjYg8=";

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Experimental JSONPath engine for querying massive streamed datasets";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rq";
  };
}
