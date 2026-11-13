{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "gh-aw";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-aw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/vDh6BRcswm5U0l72RO1nzEVsvyDd0Q5s1v0SrQTtpk=";
  };

  vendorHash = "sha256-2vQSd+Esu0qEembWIiH6/3mzEdmiNwAbkZSfk5cwAUA=";

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
