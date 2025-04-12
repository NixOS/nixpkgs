{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  pname = "grip-grab";
  version = "0.6.7";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "grip-grab";
    rev = "refs/tags/v${version}";
    hash = "sha256-e7duLL4tjW+11jXUqU6sqoKTAPGkH81iDCfjtNcnd4I=";
  };

  cargoHash = "sha256-g7YdNNN6YJiW8sQa1KMj5evVbLPObRXrKM5HoG87Kxc=";

  doCheck = false;

  meta = {
    description = "Fast, more lightweight ripgrep alternative for daily use cases";
    homepage = "https://github.com/alexpasmantier/grip-grab";
    changelog = "https://github.com/alexpasmantier/grip-grab/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "gg";
  };
}
