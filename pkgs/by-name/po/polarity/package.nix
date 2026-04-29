{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polarity";
  version = "latest-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "dbcece0e8b572193a5605296392ef1f0d85bba74";
    hash = "sha256-8wVsiLSTbjIZOObdiawvQy5rw+sf93cp6+wbY+XaByI=";
  };

  cargoHash = "sha256-9PMQQHydqgeKeB0eM49dJpL+8cstK8yUkc728ATXroQ=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
})
