{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sizelint";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${version}";
    hash = "sha256-RwiopJHVyQE+WwiB5Bd89kfQxLl7TROZSB3aanf3fB0=";
  };

  cargoHash = "sha256-Kf6QreDGYM0ndmkOND4zhcDdx6SsXHuj7rcwy6tGyQk=";

  meta = {
    description = "Lint your file tree based on file sizes";
    homepage = "https://github.com/a-kenji/sizelint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "sizelint";
  };
}
