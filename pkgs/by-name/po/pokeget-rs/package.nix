{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pokeget-rs";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    tag = version;
    hash = "sha256-kvfGtdWVeEvaKxIDs5aCZk/HBXxB67PukXHz2VvLhdw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-EusvBjrtm7PAZ5exDUuCu2n300x1b1c9oks+T6cR2c8=";

  meta = with lib; {
    description = "Better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = licenses.mit;
    mainProgram = "pokeget";
    maintainers = with maintainers; [ aleksana ];
  };
}
