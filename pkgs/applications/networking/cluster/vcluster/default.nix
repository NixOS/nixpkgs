{ lib, go, buildGoModule, fetchFromGitHub, installShellFiles, testers, vcluster }:

buildGoModule rec {
  pname = "vcluster";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TJjMB7x8MOlr3GexsnOZBFPJovVkf4ByRn1aGprvZFQ=";
  };

  vendorHash = null;

  subPackages = [ "cmd/vclusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  # Test is disabled because e2e tests expect k8s.
  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/vclusterctl" -T $out/bin/vcluster
    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd vcluster \
      --bash <($out/bin/vcluster completion bash) \
      --fish <($out/bin/vcluster completion fish) \
      --zsh <($out/bin/vcluster completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = vcluster;
    command = "vcluster --version";
  };

  meta = with lib; {
    description = "Create fully functional virtual Kubernetes clusters";
    downloadPage = "https://github.com/loft-sh/vcluster";
    homepage = "https://www.vcluster.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk berryp qjoly ];
  };
}
