{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-05-14";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "6c0370011b827886e87b7afec644788a1a54f6f7";
    hash = "sha256-RKuL0gn734eqNQHIsSA0kLF1qUNtyEUpYf8Zv359GAs=";
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
