{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ahoy";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ahoy-cli";
    repo = "ahoy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zHtM9B7+hRe4GVUY58j8iW1OXzBrkiny5kclLjuVutw=";
  };

  sourceRoot = "${finalAttrs.src.name}/v2";

  # vendor folder exists
  vendorHash = null;

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

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
