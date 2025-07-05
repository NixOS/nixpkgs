{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "allfollow";
  version = "0-unstable-2024-08-31";

  src = fetchFromGitHub {
    owner = "spikespaz";
    repo = "allfollow";
    rev = "b3caf2b7c13697469e3aebe8205f5035b1e2abd1";
    hash = "sha256-VztTuzCXMvczCzngyZ+tKsi4ak5b0QeTDNlfgmCoRqw=";
  };

  cargoHash = "sha256-GRuLVYtFkzFPos1kJv51yPseFY+kWKT2oC91Kvo7pTo=";

  meta = {
    description = ''
      CLI tool to deduplicate your Nix flake's inputs as if you added `inputs.*.inputs.*.follows = "*" everywhere
    '';
    homepage = "https://github.com/spikespaz/allfollow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "allfollow";
  };
}
