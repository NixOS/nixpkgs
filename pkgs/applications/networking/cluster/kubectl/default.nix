{ stdenv, lib, kubernetes }:

stdenv.mkDerivation {
  name = "kubectl-${kubernetes.version}";

  # kubectl is currently part of the main distribution but will eventially be
  # split out (see homepage)
  src = kubernetes;

  outputs = [ "out" "man" ];

  doBuild = false;

  installPhase = ''
    mkdir -p \
      "$out/bin" \
      "$out/share/bash-completion/completions" \
      "$out/share/zsh/site-functions" \
      "$man/share/man/man1"

    cp bin/kubectl $out/bin/kubectl

    cp "${kubernetes.man}/share/man/man1"/kubectl* "$man/share/man/man1"

    $out/bin/kubectl completion bash > $out/share/bash-completion/completions/kubectl
    $out/bin/kubectl completion zsh > $out/share/zsh/site-functions/_kubectl
  '';

  meta = kubernetes.meta // {
    description = "Kubernetes CLI";
    homepage = "https://github.com/kubernetes/kubectl";
  };
}
