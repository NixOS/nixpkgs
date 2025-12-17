{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gh-nippou";
  version = "4.2.42";

  src = fetchFromGitHub {
    owner = "masutaka";
    repo = "github-nippou";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/dZ93CICUOPCI2dcT3d8o1HZL4JEsjwzYfC6PEOVixQ=";
  };

  vendorHash = "sha256-Bi79YKQGfmaDXGslG1kdtT+iBOEVh96LooT8id3G8e4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/masutaka/github-nippou/v4/cmd.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Print today's your GitHub activity for issues and pull requests";
    homepage = "https://github.com/masutaka/github-nippou";
    changelog = "https://github.com/masutaka/github-nippou/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "github-nippou";
  };
})
