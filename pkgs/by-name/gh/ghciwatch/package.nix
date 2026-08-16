{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghciwatch";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x+8cA3wO8LOB1/bMKZlKTkuts1IobEsAhRIJQWwrpjs=";
  };

  cargoHash = "sha256-ysB1BJbMJ8KSCGSQzs9AnOA4SnnRcukC5R/vU45pbRM=";

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
