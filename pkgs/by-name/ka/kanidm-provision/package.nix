{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanidm-provision";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "kanidm-provision";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pgPjkj0nMb5j3EvyJTTDpfmh0WigAcMzoleF5EOqBAM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kbctfPhEF1PdVLjE62GyLDzjOnZxH/kOWUS4x2vd/+8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "A small utility to help with kanidm provisioning";
    homepage = "https://github.com/oddlama/kanidm-provision";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ oddlama ];
    mainProgram = "kanidm-provision";
  };
})
