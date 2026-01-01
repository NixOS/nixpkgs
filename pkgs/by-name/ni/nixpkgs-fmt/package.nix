{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "nixpkgs-fmt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixpkgs-fmt";
    rev = "v${version}";
    hash = "sha256-6Ut4/ix915EoaPCewoG3KhKBA+OaggpDqnx2nvKxEpQ=";
  };

  cargoHash = "sha256-aookq6n8/dMz+REDwtSghhzcUf66D3O9SKJKx3q7lsI=";

<<<<<<< HEAD
  meta = {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zimbatm ];
=======
  meta = with lib; {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "nixpkgs-fmt";
  };
}
