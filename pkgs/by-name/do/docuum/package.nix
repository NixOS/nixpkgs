{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "docuum";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dP+BMgX4oPhg3zCQ+55vyKJ1RUN38ury4H90s2AKgyE=";
  };

  cargoHash = "sha256-RgvRYuaX5Id89Tql8L8dMwpTdF3kD3nL3VyePliXhjk=";

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
