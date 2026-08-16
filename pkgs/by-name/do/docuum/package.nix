{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "docuum";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Avd+37mY9E28kfqRI8W3Lx5O/RrxuHFwBnXZqqdrkNQ=";
  };

  cargoHash = "sha256-VrCtfE4WvTlKeLsJVm73kNvo3lH90nt+imG2Yqse8K0=";

  checkFlags = [
    # fails, no idea why
    "--skip=format::tests::code_str_display"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Least recently used (LRU) eviction of Docker images";
    homepage = "https://github.com/stepchowfun/docuum";
    changelog = "https://github.com/stepchowfun/docuum/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "docuum";
  };
})
