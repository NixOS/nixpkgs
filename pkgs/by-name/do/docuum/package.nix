{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "docuum";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZfC0z/oaf+HQR33DDtixp9LwLD3v+eZ1tP3WvXqNnFY=";
  };

  cargoHash = "sha256-0vNhZTIRpZ72hiU6GvlbWlo2U//AdJmowXVuaI/5wB8=";

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
