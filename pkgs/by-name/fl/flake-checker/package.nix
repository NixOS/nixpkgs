{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
    hash = "sha256-Uc3Fycn4SBYo2XWoAn4egAtjKt0XxBcyS0uN5a3bRKk=";
  };

  cargoHash = "sha256-Muajqf7jcr10DLythl/hlFM2qG83i81Q3eGk3mg/4GU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
    SystemConfiguration
  ]);

  meta = with lib; {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "flake-checker";
  };
}
