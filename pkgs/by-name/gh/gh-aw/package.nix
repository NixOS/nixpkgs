{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "gh-aw";
  version = "0.79.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-aw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n1w235wCvHZs48PWIu3v4qob3SQPt1kMLszHe/7Rcwg=";
  };

  vendorHash = "sha256-GgDf2Ly8Vs/FTqk3w5yNYn/X1bWyfUBWhfl8QH2WFVg=";

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
