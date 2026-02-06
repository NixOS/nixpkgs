{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  pname = "swayest-workstyle";
  version = "1.3.8";
  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    hash = "sha256-n4hQG3rZ5gVLfknQr+NOyOtRPiYgBOeIYM5f6RUuet0=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-qJ9MDpDLu6WuD8u98ef32jIJE/RZI3fYaEIa+9whB+M=";

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
