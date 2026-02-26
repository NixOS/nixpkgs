{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rt-cli";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "unvalley";
    repo = "rt";
    rev = "v${version}";
    hash = "sha256-VO3WaKbKwHCZCxKr40oNWRO5+fN0D9JBtKzPuDvoKuU=";
  };

  cargoHash = "sha256-GwTJPX60vrWzFfVuwwnO6/s0AvPY2HJSw9rAvW/EIsU=";

  meta = {
    description = "Run tasks across different task runners";
    homepage = "https://github.com/unvalley/rt";
    changelog = "https://github.com/unvalley/rt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ unvalley ];
    mainProgram = "rt";
  };
}
