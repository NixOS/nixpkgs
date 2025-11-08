{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  dnscontrol,
}:

buildGoModule rec {
  pname = "dnscontrol";
  version = "4.27.1";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = "dnscontrol";
    tag = "v${version}";
    hash = "sha256-OlXqX26aL08gft8sFPZrYBhf7U4DY46BYqli68xEPbg=";
  };

  vendorHash = "sha256-3JlPT0nL/FzjxH6aWZBwYaNetSEzzEv00/F7bsj4h0Y=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/StackExchange/dnscontrol/v${lib.versions.major version}/pkg/version.version=${version}"
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
    maintainers = with lib.maintainers; [
      SuperSandro2000
      zowoq
    ];
    mainProgram = "dnscontrol";
  };
}
