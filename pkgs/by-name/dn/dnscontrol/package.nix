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
  version = "4.23.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    tag = "v${version}";
    hash = "sha256-Jaa+geO2836kQHTRhaQru367iQvqac6sgnpL9244dkw=";
  };

  vendorHash = "sha256-PbOqi9vfz46lwoP3aUPl/JKDJtYYF7IwnN9lppZ8KYA=";

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
