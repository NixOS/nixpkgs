{
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  openssl,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "screenly-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Trq1LFmKtzCCuqOT3DeL5KAPtHWi/glmhLBTR2vdVg=";
  };

  cargoHash = "sha256-VPl9/5GkMI2oZQ9ZUwpMcW9+3SCbCpLCVrBiXneCakQ=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    changelog = "https://github.com/Screenly/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [
      vpetersson
    ];
  };
})
