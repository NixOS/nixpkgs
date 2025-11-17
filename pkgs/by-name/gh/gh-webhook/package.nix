{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gh-webhook";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "gh-webhook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y/lJmLxuTIZoxkxSksLxZ7nOBfOOSMD8Z08Ku9f0na8=";
  };

  vendorHash = "sha256-MAvrtuxB0iH+1ESYrE1JZFUE1Jy8TaAAnhTuwsh+frc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "GitHub CLI extension to chatter with Webhooks";
    homepage = "https://github.com/cli/gh-webhook";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamperkowski ];
    mainProgram = "gh-webhook";
  };
})
