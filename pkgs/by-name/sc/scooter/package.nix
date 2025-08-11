{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-9pdw7QGa+KRMlMIPrdCVIroXKNwzTl5FiP0W20Axkhk=";
  };

  cargoHash = "sha256-juLzW3gsJ/HD04ErLc9ctAhL7L7fkSzEaEedf5YFvvo=";

  # Ensure that only the `scooter` package is built (excluding `xtask`)
  cargoBuildFlags = [
    "--package"
    "scooter"
  ];

  # Many tests require filesystem writes which fail in Nix sandbox
  doCheck = false;

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/commits/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
}
