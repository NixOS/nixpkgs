{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghciwatch";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ivSn1q/E0akz2JEkGcfB8i46Vom8/Pp/DlFBI+Zmo5Q=";
  };

  cargoHash = "sha256-LZIBQ5dKtqTsMjLrhBucsgSAdmsGKkhOFtMCGh3clPk=";

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
