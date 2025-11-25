{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "infrastructure-agent";
  version = "1.71.1";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = version;
    hash = "sha256-HS6OgPi6gF1LB7BgFeLL3Wpvwu7sv9YoR3VBytLrd0Y=";
  };

  vendorHash = "sha256-H41FxeJLrlaL/KbcBAS1WuMfVn6d+4So3egXb6E46/o=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${version}"
    "-X main.gitCommit=${src.rev}"
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
}
