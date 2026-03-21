{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pokeget-rs";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "talwat";
    repo = "pokeget-rs";
    tag = finalAttrs.version;
    hash = "sha256-kvfGtdWVeEvaKxIDs5aCZk/HBXxB67PukXHz2VvLhdw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-EusvBjrtm7PAZ5exDUuCu2n300x1b1c9oks+T6cR2c8=";

  meta = {
    description = "Better rust version of pokeget";
    homepage = "https://github.com/talwat/pokeget-rs";
    license = lib.licenses.mit;
    mainProgram = "pokeget";
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
