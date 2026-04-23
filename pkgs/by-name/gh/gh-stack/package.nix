{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-stack";
  version = "0.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-stack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-om7ekHez08X1YjP0W+3p0PxmjU/za6+/gHX5GPakKAw=";
  };

  vendorHash = "sha256-s85Lz6yfY1TiIFPolU1qESDyw8XoBORyuOMdiHj6Grc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/github/gh-stack/cmd.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitHub CLI extension to use stacked PRs";
    homepage = "https://github.github.com/gh-stack/";
    downloadPage = "https://github.com/github/gh-stack/";
    changelog = "https://github.com/github/gh-stack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "gh-stack";
  };
})
