{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ahoy";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "ahoy-cli";
    repo = "ahoy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wYsPutdO9ZkXQu4mrFV56mrJTeSFF/3oRaHO0ia7DHk=";
  };

  sourceRoot = "${finalAttrs.src.name}/v2";

  # vendor folder exists
  vendorHash = null;

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Create self-documenting cli programs from YAML files";
    homepage = "https://github.com/ahoy-cli/ahoy";
    changelog = "https://github.com/ahoy-cli/ahoy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "ahoy";
  };
})
