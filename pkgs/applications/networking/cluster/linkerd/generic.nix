{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

{ channel, version, sha256, vendorHash }:

buildGoModule rec {
  pname = "linkerd-${channel}";
  inherit version vendorHash;

  src = fetchFromGitHub {
    owner = "linkerd";
    repo = "linkerd2";
    rev = "${channel}-${version}";
    inherit sha256;
  };

  subPackages = [ "cli" ];

  preBuild = ''
    env GOFLAGS="" go generate ./pkg/charts/static
    env GOFLAGS="" go generate ./jaeger/static
    env GOFLAGS="" go generate ./multicluster/static
    env GOFLAGS="" go generate ./viz/static

    # Necessary for building Musl
    if [[ $NIX_HARDENING_ENABLE =~ "pie" ]]; then
        export GOFLAGS="-buildmode=pie $GOFLAGS"
    fi
  '';

  tags = [
    "prod"
  ];

  ldflags = [
    "-s" "-w"
    "-X github.com/linkerd/linkerd2/pkg/version.Version=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cli $out/bin/linkerd
    installShellCompletion --cmd linkerd \
      --bash <($out/bin/linkerd completion bash) \
      --zsh <($out/bin/linkerd completion zsh) \
      --fish <($out/bin/linkerd completion fish)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/linkerd version --client | grep ${src.rev} > /dev/null
  '';

  passthru.updateScript = (./. + "/update-${channel}.sh");

  meta = with lib; {
    description = "A simple Kubernetes service mesh that improves security, observability and reliability";
    mainProgram = "linkerd";
    downloadPage = "https://github.com/linkerd/linkerd2/";
    homepage = "https://linkerd.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bryanasdev000 Gonzih ];
  };
}
