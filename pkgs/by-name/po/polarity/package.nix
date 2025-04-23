{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "9ee17a9a167efdd660c4806e2d3cd5bc2b3177e1";
    hash = "sha256-9MsPMQnqzePhxF9f9DgmZ9aq8TzLYi3jZA9HF2McVss=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-23qr4bEAsN75ONnNmym9eWH38fRoMmP1EkmOaka73Ko=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Language with Dependent Data and Codata Types";
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
