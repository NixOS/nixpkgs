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
  version = "1.3.32";

  src = fetchFromGitHub {
    owner = "gpu-mode";
    repo = "popcorn-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QLUgr1e6ExK/uSTm0bz2ThAJZ9cxo9rYo+BgJ/cjS5o=";
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
