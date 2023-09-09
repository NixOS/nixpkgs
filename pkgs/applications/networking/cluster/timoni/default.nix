{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "timoni";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    rev = "v${version}";
    hash = "sha256-GILJAaid1kSO9281HQx7NI+mjmyJbTYTkwhvX4V/Idc=";
  };

  vendorHash = "sha256-nGYAk9dwQ/+3SmNqGzbpptqBDAO/vNT9jhlcJf4y8jg=";

  subPackages = [ "cmd/timoni" ];
  nativeBuildInputs = [ installShellFiles ];

  # Some tests require running Kubernetes instance
  doCheck = false;

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
    license = licenses.asl20;
    maintainers = with maintainers; [ votava ];
  };
}
