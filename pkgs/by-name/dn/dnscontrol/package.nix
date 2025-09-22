{
  lib,
  stdenv,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
  testers,
  dnscontrol,
}:

buildGo125Module rec {
  pname = "dnscontrol";
  version = "4.25.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    tag = "v${version}";
    hash = "sha256-8VNo2IPchplTlI97BzsGcc6i0z7V79oHkSVtCLY8558=";
  };

  vendorHash = "sha256-Ob6TP81pnsX/uzEh0ekz+koVoC/tqC/3P4wAShnQOVc=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/StackExchange/dnscontrol/v4/pkg/version.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
