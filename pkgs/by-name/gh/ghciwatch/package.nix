{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ghciwatch";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${version}";
    hash = "sha256-K7BNGRilzi01loE0yS4CZFDNz8TQ9Z+fELO5HUvGObE=";
  };

  cargoHash = "sha256-kH5YTadpaUXDma+7SfBJxrOIsd9Gm0EU3MfhFmQ3U80=";

  # integration tests are not run but the macros need this variable to be set
  GHC_VERSIONS = "";
  checkFlags = "--test \"unit\"";

  meta = with lib; {
    description = "Ghci-based file watching recompiler for Haskell development";
    homepage = "https://github.com/MercuryTechnologies/ghciwatch";
    license = licenses.mit;
    maintainers = with maintainers; [
      mangoiv
      _9999years
    ];
    mainProgram = "ghciwatch";
  };

  passthru.updateScript = nix-update-script { };
}
