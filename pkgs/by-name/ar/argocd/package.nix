{ lib, buildGoModule, fetchFromGitHub, installShellFiles, stdenv }:

buildGoModule rec {
  pname = "argocd";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
    hash = "sha256-0qL9CnEwEp7sJK7u6EKHVFY/hH8lTb182HZ3r+9nIyQ=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-p+9Q9VOdN7v7iK5oaO5f+B1iyOwVdk672zQsYsrb398=";

  # Set target as ./cmd per cli-local
  # https://github.com/argoproj/argo-cd/blob/master/Makefile#L227
  subPackages = [ "cmd" ];

  ldflags =
    let package_url = "github.com/argoproj/argo-cd/v2/common"; in
    [
      "-s" "-w"
      "-X ${package_url}.version=${version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${src.rev}"
      "-X ${package_url}.gitTag=${src.rev}"
      "-X ${package_url}.gitTreeState=clean"
      "-X ${package_url}.kubectlVersion=v0.31.2"
      # NOTE: Update kubectlVersion when upgrading this package with
      # https://github.com/search?q=repo%3Aargoproj%2Fargo-cd+%22k8s.io%2Fkubectl%22+path%3Ago.mod&type=code
      # Per https://github.com/search?q=repo%3Aargoproj%2Fargo-cd+%22KUBECTL_VERSION%3D%22+path%3AMakefile&type=code
      # Will need a way to automate it :P
    ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cmd" -T $out/bin/argocd
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/argocd version --client | grep ${src.rev} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd argocd \
      --bash <($out/bin/argocd completion bash) \
      --fish <($out/bin/argocd completion fish) \
      --zsh <($out/bin/argocd completion zsh)
  '';

  meta = with lib; {
    description = "Declarative continuous deployment for Kubernetes";
    mainProgram = "argocd";
    downloadPage = "https://github.com/argoproj/argo-cd";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ shahrukh330 bryanasdev000 qjoly ];
  };
}
