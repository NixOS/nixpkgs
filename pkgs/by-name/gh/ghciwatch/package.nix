{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghciwatch";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ho6j9/MKvLNbgWqGNTCHLacyka6Nf8qchjG4YnsK7wA=";
  };

  cargoHash = "sha256-BUtUcqYYYiA3ulrCXlA6stcONxTvilKEDO+Vq3Pvok8=";

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
