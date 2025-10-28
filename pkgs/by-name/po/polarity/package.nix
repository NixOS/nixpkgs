{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-10-27";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "bac4a2ba743551fe5986d8b4e840ee53ae8e065d";
    hash = "sha256-7sp/7U1AoudUEEM9Pa4BcXNRiym70MnOx3NiSUOQb9o=";
  };

  cargoHash = "sha256-DyqK5cxdsZWMr79clw8oRHTAAlzGzP8i4Vu/UXH/ptE=";

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
