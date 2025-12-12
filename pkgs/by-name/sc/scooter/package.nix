{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-hOuhgPE24DBF/uFz/S51h+d7j5yDjPs8Mvfkcp2BQsc=";
  };

  cargoHash = "sha256-S2oLItnyRURPyYDroa7PlHbKIhnE4HdXeo1y6cAKvss=";

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
