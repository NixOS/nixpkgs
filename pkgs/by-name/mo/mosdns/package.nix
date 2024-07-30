{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  mosdns,
  stdenv,
  installShellFiles,
}:

buildGoModule rec {
  pname = "mosdns";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "IrineSistiana";
    repo = "mosdns";
    rev = "refs/tags/v${version}";
    hash = "sha256-QujkDx899GAImEtQE28ru7H0Zym5SYXJbJEfSBkJYjo=";
  };

  vendorHash = "sha256-0J5hXb1W8UruNG0KFaJBOQwHl2XiWg794A6Ktgv+ObM=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mosdns \
      --bash <($out/bin/mosdns completion bash) \
      --fish <($out/bin/mosdns completion fish) \
      --zsh <($out/bin/mosdns completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = mosdns;
      command = "${lib.getExe mosdns} version";
    };
  };

  meta = {
    description = "Modular, pluggable DNS forwarder";
    homepage = "https://github.com/IrineSistiana/mosdns";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mosdns";
  };
}
