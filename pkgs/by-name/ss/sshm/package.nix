{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sshm";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Gu1llaum-3";
    repo = "sshm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eqObVdyfGAD+kiIvRZZOHPVtFzYnGztVn2odsE+voLI=";
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
