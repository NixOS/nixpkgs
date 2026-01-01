{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-checker";
<<<<<<< HEAD
  version = "0.2.10";
=======
  version = "0.2.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "flake-checker";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/hwcRsaVdLvjKnCjFzy4T/zdvWjWAMBtfgJX/cNpmOc=";
  };

  cargoHash = "sha256-5pK0l84L4cEhw5d8n8j6JWEXEbsmWHmHJxB5ZMrnAU0=";

  meta = {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucperkins ];
=======
    hash = "sha256-elHpiMGwJ2KnN75EOTjsjpziYfXiRyTeixhY4rd85m0=";
  };

  cargoHash = "sha256-QS38tAJ1V0Avd7N+Mhexv23oh+kxtmr/qvQZLRwP9zA=";

  meta = with lib; {
    description = "Health checks for your Nix flakes";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "https://github.com/${src.owner}/${src.repo}/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "flake-checker";
  };
}
