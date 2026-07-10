{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "gh-aw";
  version = "0.80.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-aw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2BGFKy/X8j0jYQc+W2rLZmZmPgCvZ+QOZweQaAQQJLM=";
  };

  vendorHash = "sha256-jxh8R/X12/QHxZOIKsTvS6FcDQSmJ7RJEvDnJuUr93A=";

  subPackages = [ "cmd/gh-aw" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/github/gh-aw";
    description = "gh extension for GitHub Agentic Workflows";
    longDescription = ''
      Repository automation, running the coding agents you know and
      love, with strong guardrails in GitHub Actions.
    '';
    changelog = "https://github.com/github/gh-aw/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/github/gh-aw/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MH0386 ];
    mainProgram = "gh-aw";
  };
})
