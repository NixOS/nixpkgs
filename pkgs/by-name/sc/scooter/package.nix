{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-DgxyurJmhpTHdmLyRaZkfiPYdMYdqeQOC+ZncfW5GdQ=";
  };

  cargoHash = "sha256-vq2d6UX4TbPO6Uya3m8uKff7+w1+VfV4Bec4Uyx/8pQ=";

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
