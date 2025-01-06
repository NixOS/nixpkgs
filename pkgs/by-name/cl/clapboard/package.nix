{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "clapboard";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "clapboard";
    rev = "v${version}";
    hash = "sha256-/4HBhsW2C3xYzKVw9TuSj8b7LdirWbNg4OxLm/ebf40=";
  };

  cargoHash = "sha256-bq+r2J2lhhZKTEV69OnsXiAGKspOZ0kF0q2hDnbIXn8=";

  meta = {
    description = "Wayland clipboard manager that will make you clap";
    homepage = "https://github.com/bjesus/clapboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    platforms = lib.platforms.linux;
    mainProgram = "clapboard";
  };
}
