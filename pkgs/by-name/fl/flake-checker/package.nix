{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
    hash = "sha256-RwkyyrWm0QRNOn7Bb9jKOyJ049B6pPmhbrx8tXpUf4w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lB7+2dQGfbn7IhmCAN0jvFTGjJDBpw57VHi3qIwwOZ4=";

  meta = with lib; {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
}
