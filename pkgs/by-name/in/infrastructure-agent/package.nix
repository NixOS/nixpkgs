{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "infrastructure-agent";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = finalAttrs.version;
    hash = "sha256-7sdx+TCr8vWevSSnlq5p/roh55jS2vxVCNcxGaDZDlI=";
  };

  vendorHash = "sha256-DeQiYKqsFG2IodmgZEKmJsCsxJzdKH1cDHz1nwX3sKo=";

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
