{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-stack";
  version = "0.0.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-stack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CwUDoLLcEsA+dlPDLqQnBLqdtNQwDW6ghmTkyXMpM4M=";
  };

  vendorHash = "sha256-JnuqORtdW+xz8pAGAFXdjRey8jCEj+miJiyfY7gzRSU=";

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
