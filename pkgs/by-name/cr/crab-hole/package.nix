{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "crab-hole";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "LuckyTurtleDev";
    repo = "crab-hole";
    tag = "v${version}";
    hash = "sha256-z3lwhcpX76OHBlDQLmd/SmRaZMEjdaAHmjzn6ucOudk=";
  };

  cargoHash = "sha256-PDDw/5VRZWGzG2LhS7go0HvYhPO8PwBcsmlLWjBfP8Q=";

  meta = {
    description = "Pi-Hole clone written in Rust using Hickory DNS";
    homepage = "https://github.com/LuckyTurtleDev/crab-hole";
    license = lib.licenses.agpl3Plus;
    mainProgram = "crab-hole";
    maintainers = [
      lib.maintainers.NiklasVousten
    ];
    platforms = lib.platforms.linux;
  };
}
