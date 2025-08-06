{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  dnscontrol,
}:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.22.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    tag = "v${version}";
    hash = "sha256-5K2o0qa+19ur6axDrVkhDDoTMzRO/oNYIGJciIKGvII=";
  };

  vendorHash = "sha256-hniL/pFbYOjpLuAHdH0gD0kFKnW9d/pN7283m9V3e/0=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/StackExchange/dnscontrol/v4/pkg/version.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd dnscontrol \
      --bash <($out/bin/dnscontrol shell-completion bash) \
      --zsh <($out/bin/dnscontrol shell-completion zsh)
  '';

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  passthru.tests = {
    version = testers.testVersion {
      command = "${lib.getExe dnscontrol} version";
      package = dnscontrol;
    };
  };

  meta = {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://dnscontrol.org/";
    changelog = "https://github.com/StackExchange/dnscontrol/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "dnscontrol";
  };
}
