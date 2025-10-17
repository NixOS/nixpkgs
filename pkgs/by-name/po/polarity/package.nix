{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "08e5ab1593ec2658bcd87b8e915098c218112691";
    hash = "sha256-cJDdPUNx7greggrNXuRJ+vq+cr8FlacaSNGIamJSdck=";
  };

  cargoHash = "sha256-ikjFczHc7iPUAksbo9URQN4YCz6DP61p5HhOEhZTqo0=";

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
