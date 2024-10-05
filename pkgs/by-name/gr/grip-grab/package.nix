{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "grip-grab";
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "grip-grab";
    rev = "refs/tags/v${version}";
    hash = "sha256-5nKDeJ5d9ECd9zvSK22zN15m8qCt/L3VKem9hVQzLzU=";
  };

  cargoHash = "sha256-NEoZYdZEhT4gPMm9fUn3WbFPIcjVhLLFxEvbQxVHV+k=";

  meta = {
    description = "Fast, more lightweight ripgrep alternative for daily use cases";
    homepage = "https://github.com/alexpasmantier/grip-grab";
    changelog = "https://github.com/alexpasmantier/grip-grab/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "gg";
  };
}
