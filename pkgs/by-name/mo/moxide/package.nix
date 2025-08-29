{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "moxide";
  version = "0.3.0";

  cargoHash = "sha256-j4yV86Hr6QZTZ/0Dy9y+2egxGqf1Z930Zg6dsKs5bxg=";
  src = fetchFromGitHub {
    owner = "dlurak";
    repo = "moxide";
    tag = "v${version}";
    hash = "sha256-BTg1z3pU9mGnexlXBdJ5ZqJeykpzGmhCbEKtvVxGEKo=";
  };

  meta = {
    description = "Tmux session manager with a modular configuration";
    mainProgram = "moxide";
    homepage = "https://github.com/dlurak/moxide";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dlurak ];
  };
}
