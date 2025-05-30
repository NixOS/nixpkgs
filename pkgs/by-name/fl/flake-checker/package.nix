{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
    hash = "sha256-Q1nC7U4SG3VHlqbJDs5NDNmsvnYN+MGpMkOH952WaKg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-M+Ftovr1Czk9W904B2Cf9FjItKhxALZj6mT+Yewdf8U=";

  meta = with lib; {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
}
