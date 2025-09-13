{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-08-24";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "5e208207cfee3fbefd16dd6c0ef5e9f086597374";
    hash = "sha256-8/edtUEoDtIwqBtUi5OdyQ+aHSnbXS4R1ltZYLQIehM=";
  };

  cargoHash = "sha256-EB6DlhD+0oneAGhLHi3bWnnFUIfNdKeW52umWHZEP7c=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}
