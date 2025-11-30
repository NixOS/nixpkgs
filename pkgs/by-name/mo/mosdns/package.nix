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
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "IrineSistiana";
    repo = "mosdns";
    tag = "v${version}";
    hash = "sha256-nSqSfbpi91W28DaLjCsWlPiLe1gLVHeZnstktc/CLag=";
  };

  vendorHash = "sha256-RpvWkIDhHSNbdkpBCcXYbbvbmGiG15qyB5aEJRmg9s4=";

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
