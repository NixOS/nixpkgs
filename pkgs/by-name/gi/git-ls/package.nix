{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "git-ls";
  version = "6.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "llimllib";
    repo = "git-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSSddZRgYYQcHQA7ZVGLx/iZFx0crFiSY/EF2luWVjA=";
  };

  vendorHash = "sha256-Bk6IBG+BrqY4FNVIlbSSSnqqAeL+8SJUtRXuIp4e8f8=";

  ldflags = [ "-s" ];

  nativeCheckInputs = [
    gitMinimal
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "List files and git status in a repository";
    homepage = "https://github.com/llimllib/git-ls";
    changelog = "https://github.com/llimllib/git-ls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "git-ls";
  };
})
