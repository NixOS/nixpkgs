{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanidm-provision";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m3bF4wFPVRc2E+E/pZc3js9T4rYbTejo/FFpysytWKw=";
  };

  cargoHash = "sha256-dPTrIc/hTbMlFDXYMk/dTjqaNECazldfW43egDOwyLM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) kanidm-provisioning; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ oddlama ];
    mainProgram = "kanidm-provision";
  };
})
