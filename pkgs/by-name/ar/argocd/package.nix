{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "argocd";
  version = "2.14.11";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-cd";
    rev = "v${version}";
    hash = "sha256-KCU/WMytx4kOzlkZDwLfRRfutBtdk6UVBNdXOWC5kWc=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-Xm9J08pxzm3fPQjMA6NDu+DPJGsvtUvj+n/qrOZ9BE4=";

  # Set target as ./cmd per cli-local
  # https://github.com/argoproj/argo-cd/blob/master/Makefile#L227
  subPackages = [ "cmd" ];

  ldflags =
    let
      packageUrl = "github.com/argoproj/argo-cd/v2/common";
    in
    [
      "-s"
      "-w"
      "-X ${packageUrl}.version=${version}"
      "-X ${packageUrl}.buildDate=unknown"
      "-X ${packageUrl}.gitCommit=${src.rev}"
      "-X ${packageUrl}.gitTag=${src.rev}"
      "-X ${packageUrl}.gitTreeState=clean"
    ];

  nativeBuildInputs = [ installShellFiles ];

  # set ldflag for kubectlVersion since it is needed for argo
  # Per https://github.com/search?q=repo%3Aargoproj%2Fargo-cd+%22KUBECTL_VERSION%3D%22+path%3AMakefile&type=code
  prePatch = ''
    export KUBECTL_VERSION=$(grep 'k8s.io/kubectl v' go.mod | cut -f 2 -d " " | cut -f 1 -d "=" )
    echo using $KUBECTL_VERSION
    ldflags="''${ldflags} -X github.com/argoproj/argo-cd/v2/common.kubectlVersion=''${KUBECTL_VERSION}"
  '';
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Declarative continuous deployment for Kubernetes";
    mainProgram = "argocd";
    downloadPage = "https://github.com/argoproj/argo-cd";
    homepage = "https://argo-cd.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      shahrukh330
      bryanasdev000
      qjoly
      FKouhai
    ];
  };
}
