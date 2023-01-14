{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "argocd";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
    sha256 = "sha256-R00HW4jh6zohMoli9aomPCK/svzWSUi9fcRFvevMhyU=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-F5EY1/WWRPBN5fqp2J2mdpIzL1gNKR0ltzSdarT6dFw=";

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
      "-X ${package_url}.kubectlVersion=v0.24.2"
      # NOTE: Update kubectlVersion when upgrading this package with
      # https://github.com/argoproj/argo-cd/blob/v${version}/go.mod#L95
      # Per https://github.com/argoproj/argo-cd/blob/master/Makefile#L18
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

  postInstall = ''
    installShellCompletion --cmd argocd \
      --bash <($out/bin/argocd completion bash) \
      --zsh <($out/bin/argocd completion zsh)
  '';

  meta = with lib; {
    description = "Declarative continuous deployment for Kubernetes";
    downloadPage = "https://github.com/argoproj/argo-cd";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ shahrukh330 bryanasdev000 ];
  };
}
