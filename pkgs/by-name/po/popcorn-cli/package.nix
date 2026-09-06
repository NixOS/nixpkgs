{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "popcorn-cli";
  version = "1.3.31";

  src = fetchFromGitHub {
    owner = "gpu-mode";
    repo = "popcorn-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GX5uspmQIff9BeF4RIp6xpP/n08ZXIpFosBmM2vNjh0=";
  };

  cargoHash = "sha256-hVmsLNBZLXP6fqc30Q6ZAVYlLTIJKWujNStuEPFDeYk=";

  env.CLI_VERSION = finalAttrs.version;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for submitting solutions to the Popcorn Discord Bot";
    homepage = "https://github.com/gpu-mode/popcorn-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethanthoma ];
    mainProgram = "popcorn-cli";
  };
})
