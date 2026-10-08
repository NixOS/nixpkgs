{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  mosdns,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "mosdns";
  version = "5.3.4";

  src = fetchFromGitHub {
    owner = "IrineSistiana";
    repo = "mosdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N0JY0brs9IXx3L+sz66JniRaBzY0bGD8PawJ1WA3tkw=";
  };

  vendorHash = "sha256-FfCA5204MP+m5nkzj/jLDh5NzpD1EtrL7owmcvZhOBU=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
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
})
