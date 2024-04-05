{ lib
, buildGo122Module
, fetchFromGitHub
, installShellFiles
}:

buildGo122Module rec {
  pname = "timoni";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    rev = "v${version}";
    hash = "sha256-zQawfzwQNQvtta7lIOtePGI67Y4iXzEBGqd5YiOKAVY=";
  };

  vendorHash = "sha256-xQgSABaWY5FWHh2kcBB36fm3povFNpU18PjD4J6M4QM=";

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
    description = "A package manager for Kubernetes, powered by CUE and inspired by Helm";
    mainProgram = "timoni";
    license = licenses.asl20;
    maintainers = with maintainers; [ votava ];
  };
}
