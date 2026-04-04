{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghciwatch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JN2FnYHORvlqhsQF5Widm7G7Jyk8/iLCnQ+lLsklX1k=";
  };

  cargoHash = "sha256-RdoGS5VTesLaPiNeSEDrwP7ZuYWiz9uewlCntn7CqYc=";

  # integration tests are not run but the macros need this variable to be set
  env.GHC_VERSIONS = "";
  checkFlags = "--test \"unit\"";

  meta = {
    description = "Ghci-based file watching recompiler for Haskell development";
    homepage = "https://github.com/MercuryTechnologies/ghciwatch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mangoiv
      _9999years
    ];
    mainProgram = "ghciwatch";
  };

  passthru.updateScript = nix-update-script { };
})
