{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "npingler";
  version = "unstable-2025-08-26";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    rev = "13781b1ee6a141dfebdaa4d885e153e1147a2312";
    hash = "sha256-cWWzXsxvsETm3+91PuRnR27hSZZWVKnWU3YiTvB+t6A=";
  };

  cargoHash = "sha256-71uqdWsXBd6qsplwI3cA2TxXoj6JOThEHxnv9u6iraQ=";

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
}
