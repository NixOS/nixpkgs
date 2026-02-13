{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "infrastructure-agent";
  version = "1.72.2";

  src = fetchFromGitHub {
    owner = "newrelic";
    repo = "infrastructure-agent";
    rev = finalAttrs.version;
    hash = "sha256-GcQ/UUznuWdAtOyCC4qLQfItm81zwryV2gDDlYKFONI=";
  };

  vendorHash = "sha256-H41FxeJLrlaL/KbcBAS1WuMfVn6d+4So3egXb6E46/o=";

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
