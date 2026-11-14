{
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "flyline";
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bKFTAAN+A3Po0PnVv1XYQyLWqBQT3btYUUuFu7jcCXA=";
  };

  cargoHash = "sha256-6nEcshn1IuF1QHcsqoFbw/q7Px5CAYxqhOvU/twfyAs=";

  checkFlags = [
    # docker_integration_tests fails
    "--skip=test_bash_3_2_57"
    "--skip=test_bash_4_4_18"
    "--skip=test_bash_4_4_rc1"
    "--skip=test_bash_5_0"
    "--skip=test_bash_5_3"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bash plugin to replace readline for a modern line editing experience";
    homepage = "https://github.com/HalFrgrd/flyline";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lwb-2021 ];
  };
})
