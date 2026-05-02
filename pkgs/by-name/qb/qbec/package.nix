{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "qbec";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pdsS4jkfn64efZ2DWkP8+vrCKv09LFwDVJc/ZlPMuVc=";
  };

  vendorHash = "sha256-LXgOkmtKyUbpohUptcvwZQvgBQBBrOaQqnktaC4FLT0=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/splunk/qbec/internal/commands.version=${finalAttrs.version}"
    "-X github.com/splunk/qbec/internal/commands.commit=${finalAttrs.src.rev}"
    "-X github.com/splunk/qbec/internal/commands.goVersion=${lib.getVersion go}"
  ];

  meta = {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ groodt ];
  };
})
