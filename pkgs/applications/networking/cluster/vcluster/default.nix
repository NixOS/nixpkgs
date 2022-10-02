{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "vcluster";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KRm6+WRMGzM7L17ABj/g6Nu+eU6F3C4a9CAa0ePC6i8=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/vclusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

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
      --zsh <($out/bin/vcluster completion zsh)
  '';

  meta = with lib; {
    description = "Create fully functional virtual Kubernetes clusters";
    downloadPage = "https://github.com/loft-sh/vcluster";
    homepage = "https://www.vcluster.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk berryp ];
  };
}
