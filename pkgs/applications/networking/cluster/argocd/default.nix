{ lib, buildGoModule, fetchFromGitHub, packr, makeWrapper, installShellFiles, helm, kustomize }:

buildGoModule rec {
  pname = "argocd";
  version = "2.0.5";
  commit = "4c94d886f56bcb2f9d5b3251fdc049c2d1354b88";
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = tag;
    sha256 = "sha256-8YymSR15e+6gGGqr5CH4ERHN8RO3wd9NJkM9K7InlFU=";
  };

  vendorSha256 = "sha256-9dVkGl0gjjMehG2nt1eNpNT5fD9GbJ1mNMzYS8FTm08=";

  nativeBuildInputs = [ packr makeWrapper installShellFiles ];

  # run packr to embed assets
  preBuild = ''
    packr
  '';

  buildFlagsArray =
    let package_url = "github.com/argoproj/argo-cd/v2/common"; in
    [
      "-ldflags="
      "-s -w"
      "-X ${package_url}.version=${version}"
      "-X ${package_url}.buildDate=unknown"
      "-X ${package_url}.gitCommit=${commit}"
      "-X ${package_url}.gitTag=${tag}"
      "-X ${package_url}.gitTreeState=clean"
    ];

  # Test is disabled because ksonnet is missing from nixpkgs.
  # Log: https://gist.github.com/superherointj/79cbdc869dfd44d28a10dc6746ecb3f9
  doCheck = false;
  checkInputs = [
    helm
    kustomize
    #ksonnet
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/argocd version --client | grep ${tag} > /dev/null
    $out/bin/argocd-util version | grep ${tag} > /dev/null
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cmd" -T $out/bin/argocd
    runHook postInstall
  '';

  postInstall = ''
    for appname in argocd-util argocd-server argocd-repo-server argocd-application-controller argocd-dex ; do
      makeWrapper $out/bin/argocd $out/bin/$appname --set ARGOCD_BINARY_NAME $appname
    done
    installShellCompletion --cmd argocd \
      --bash <($out/bin/argocd completion bash) \
      --zsh <($out/bin/argocd completion zsh)
  '';

  meta = with lib; {
    description = "Declarative continuous deployment for Kubernetes";
    downloadPage = "https://github.com/argoproj/argo-cd";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ shahrukh330 superherointj ];
  };
}
