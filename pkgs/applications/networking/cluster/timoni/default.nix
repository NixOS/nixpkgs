{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "timoni";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    rev = "v${version}";
    hash = "sha256-nI0yy/zhsJUvisHo+C+/uNRF96ZQ1Ve8VWpE8ZvUeJc=";
  };

  vendorHash = "sha256-YpwESaR+X2eOyaPdR+I3mURD7yvwzmpPmgPoSPrXjH8=";

  subPackages = [ "cmd/timoni" ];
  nativeBuildInputs = [ installShellFiles ];

  # Some tests require running Kubernetes instance
  doCheck = false;

  passthru.updateScript = ./update.sh;

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd timoni \
    --bash <($out/bin/timoni completion bash) \
    --fish <($out/bin/timoni completion fish) \
    --zsh <($out/bin/timoni completion zsh)
  '';

  meta = with lib; {
    homepage = "https://timoni.sh";
    changelog = "https://github.com/stefanprodan/timoni/releases/tag/${src.rev}";
    description = "Package manager for Kubernetes, powered by CUE and inspired by Helm";
    mainProgram = "timoni";
    license = licenses.asl20;
    maintainers = with maintainers; [ votava ];
  };
}
