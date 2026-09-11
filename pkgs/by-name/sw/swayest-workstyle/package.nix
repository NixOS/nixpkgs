{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  pname = "swayest-workstyle";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    hash = "sha256-V1vEGz2jZHPdeKL99ILeoWVsuxIMkDHHdzgY8kEe9yM=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-cQWmtZFvpgFt49cKXEKUJoZ4d8w4AcwA9ud/W/rmOP8=";

  # No tests
  doCheck = false;

  meta = {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = lib.licenses.mit;
    mainProgram = "sworkstyle";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
