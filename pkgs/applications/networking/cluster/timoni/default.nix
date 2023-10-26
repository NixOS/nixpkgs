{ lib
, buildGo121Module
, fetchFromGitHub
, installShellFiles
}:

buildGo121Module rec {
  pname = "timoni";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    rev = "v${version}";
    hash = "sha256-45OIj57gb8njYoks7SgIlcMjz07ShEz2G/EECaTRTQg=";
  };

  vendorHash = "sha256-lRZFRnft8vEntVxiLOBcR00FP8AXexLyo3h2LCNWN00=";

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
