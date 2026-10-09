{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rosa-backdoor-detector";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "binsec";
    repo = "rosa";
    tag = finalAttrs.version;
    hash = "sha256-LqwtJnCfWpQ3iBOPhFIIvRKHSAXp+WcuE/ixuGUcMRE=";
  };

  cargoHash = "sha256-IleXbym7nT/mFr+BDazyPrsc1ciizgnjuxgWLmHfClg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ROSA: Finding Backdoors with Fuzzing";
    homepage = "https://github.com/binsec/rosa";
    changelog = "https://github.com/binsec/rosa/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rosa";
  };
})
