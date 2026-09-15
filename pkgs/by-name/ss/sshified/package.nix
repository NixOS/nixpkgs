{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sshified";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "hoffie";
    repo = "sshified";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4xPeUdmwTzhNmBjmmhyZKp2p2RNdTNJRnJ19/A7xHPM=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Proxy HTTP requests through SSH";
    homepage = "https://github.com/hoffie/sshified";
    changelog = "https://github.com/hoffie/sshified/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ joinemm ];
    mainProgram = "sshified";
  };
})
