{ stdenv, kubernetes, installShellFiles }:

stdenv.mkDerivation {
  pname = "kubectl";
  version = kubernetes.version;

  # kubectl is currently part of the main distribution but will eventially be
  # split out (see homepage)
  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  installPhase = ''
    install -D ${kubernetes}/bin/kubectl -t $out/bin

    installManPage "${kubernetes.man}/share/man/man1"/kubectl*

    installShellCompletion --cmd kubectl \
      --bash <($out/bin/kubectl completion bash) \
      --zsh <($out/bin/kubectl completion zsh)
  '';

  meta = kubernetes.meta // {
    description = "Kubernetes CLI";
    homepage = "https://github.com/kubernetes/kubectl";
  };
}
