{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "infrastructure-agent";
  version = "1.80.4";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = finalAttrs.version;
    hash = "sha256-hyIVtO11kLc80XCCOzzilc82U+sd/lFPDqIEIdq7mmA=";
  };

  vendorHash = "sha256-4n1mTT5DH2+wWcLPXSLNP1I6FYeE4jezMWmexZcnkOo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${finalAttrs.version}"
    "-X main.gitCommit=${finalAttrs.src.rev}"
  ];

  env.CGO_ENABLED = if stdenv.hostPlatform.isDarwin then "1" else "0";

  subPackages = [
    "cmd/newrelic-infra"
    "cmd/newrelic-infra-ctl"
    "cmd/newrelic-infra-service"
  ];

  meta = {
    description = "New Relic Infrastructure Agent";
    homepage = "https://github.com/newrelic/infrastructure-agent.git";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "newrelic-infra";
  };
})
