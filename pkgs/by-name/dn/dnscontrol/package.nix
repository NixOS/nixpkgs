{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
  testers,
  dnscontrol,
}:

buildGo125Module rec {
  pname = "dnscontrol";
  version = "4.24.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    tag = "v${version}";
    hash = "sha256-DAH6XpRZz6KnkUYcQVWqLc3GP//dgojYH5AUvJ/X7v8=";
  };

  vendorHash = "sha256-lY4E0ediBPsOXL/1KKu0QeYC0llswzYYV4JvtxMQ+PE=";

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
