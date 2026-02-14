{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "gh-aw";
  version = "0.43.21";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-aw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Wyp9tvphl++SqVgh7AlqshpZOLltOCYXqsqwKkF5js=";
  };

  vendorHash = "sha256-Ihj0mDpZNCu5PX35+fjxdLJ3+tYo3aDkjwP7bKgwXZA=";

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
