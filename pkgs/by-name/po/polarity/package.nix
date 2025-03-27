{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-03-26";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "73c91061930cf10002aae4f2dd7ac301af20dfdc";
    hash = "sha256-EN4xOBIrIrNBd/YQPc1xRagAvCdvEH83shb2axj9xX0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wpO7JYLjuEbKc/a4WO4KeUxdDCI1BswvgvSH+sFh1V0=";

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
