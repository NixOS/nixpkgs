{ lib
, buildGo121Module
, fetchFromGitHub
, installShellFiles
}:

buildGo121Module rec {
  pname = "timoni";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    rev = "v${version}";
    hash = "sha256-UYHb469x4VnFffjO9CfSyn0ZzLLaAee2WpWGFAQjBpA=";
  };

  vendorHash = "sha256-JDaQL+ferkYI74OUqgfopny8uFEg0J84JX1VtO5URpE=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ votava ];
  };
}
