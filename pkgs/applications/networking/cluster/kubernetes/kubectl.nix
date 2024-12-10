{ lib, kubernetes }:

kubernetes.overrideAttrs (_: rec {
  pname = "kubectl";

  outputs = [
    "out"
    "man"
    "convert"
  ];

  WHAT = lib.concatStringsSep " " [
    "cmd/kubectl"
    "cmd/kubectl-convert"
  ];

  installPhase = ''
    runHook preInstall
    install -D _output/local/go/bin/kubectl -t $out/bin
    install -D _output/local/go/bin/kubectl-convert -t $convert/bin

    installManPage docs/man/man1/kubectl*

    installShellCompletion --cmd kubectl \
      --bash <($out/bin/kubectl completion bash) \
      --fish <($out/bin/kubectl completion fish) \
      --zsh <($out/bin/kubectl completion zsh)
    runHook postInstall
  '';

  meta = kubernetes.meta // {
    description = "Kubernetes CLI";
    homepage = "https://github.com/kubernetes/kubectl";
    platforms = lib.platforms.unix;
  };
})
