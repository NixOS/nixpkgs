{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

let
  pname = "swayest-workstyle";
  version = "1.3.9";
  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    hash = "sha256-pytRPMGk0qwZcOnLjbYN1ijREVqCI6NZvKoFSGFmmXU=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-FM30q7Y9s5TxVFoqSarAZ3v6YaybTGpYB53fNRySnUU=";

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
