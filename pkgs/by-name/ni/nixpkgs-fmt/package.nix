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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Ut4/ix915EoaPCewoG3KhKBA+OaggpDqnx2nvKxEpQ=";
  };

  cargoHash = "sha256-yIwCBm46sgrpTt45uCyyS7M6V0ReGUXVu7tyrjdNqeQ=";

  meta = {
    description = "Nix code formatter for nixpkgs";
    homepage = "https://nix-community.github.io/nixpkgs-fmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "nixpkgs-fmt";
  };
}
