{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sshm";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Gu1llaum-3";
    repo = "sshm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vi41BWLLGZu3zd1mfT2eCzaQGLttO6fBb8kQUA8DORA=";
  };

  vendorHash = "sha256-aU/+bxcETs/Jq5FVAdiioyuc1AufvWeiqFQ7uo1cK1k=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/Gu1llaum-3/sshm/cmd.AppVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "Terminal UI to manage and connect to SSH hosts";
    homepage = "https://github.com/Gu1llaum-3/sshm";
    changelog = "https://github.com/Gu1llaum-3/sshm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cedev-1 ];
    mainProgram = "sshm";
  };
})
