{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "argocd";
  version = "2.3.2";
  tag = "v${version}";
  # Update commit to match the tag above
  # TODO make updadeScript
  commit = "ecc2af9dcaa12975e654cde8cbbeaffbb315f75c";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = tag;
    sha256 = "sha256-n+C4l4U3cDU+fgCnGWOYLdyjknw7n/xPEtC1i8AaU4o=";
  };

  vendorSha256 = "sha256-Km+1o6yuuxJs+DNTQ/XVTUFurD5gM5ohwDc7MwJuu5s=";

  # Set target as ./cmd per release-cli
  # https://github.com/argoproj/argo-cd/blob/master/Makefile#L222
  subPackages = [ "cmd" ];

  ldflags =
    let package_url = "github.com/argoproj/argo-cd/v2/common"; in
    [
      "-s" "-w"
      "-X ${package_url}.version=${version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${commit}"
      "-X ${package_url}.gitTag=${tag}"
      "-X ${package_url}.gitTreeState=clean"
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
    $out/bin/argocd version --client | grep ${tag} > /dev/null
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
