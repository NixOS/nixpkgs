{ lib, stdenv, kubernetes }:

stdenv.mkDerivation rec {
  pname = "kubectl";

  inherit (kubernetes)
    disallowedReferences
    GOFLAGS
    nativeBuildInputs
    postBuild
    postPatch
    src
    version
    ;

  outputs = [ "out" "man" ];

  WHAT = "cmd/kubectl";

  installPhase = ''
    runHook preInstall
    install -D _output/local/go/bin/kubectl -t $out/bin

    installManPage docs/man/man1/kubectl*

    installShellCompletion --cmd kubectl \
      --bash <($out/bin/kubectl completion bash) \
      --zsh <($out/bin/kubectl completion zsh)
    runHook postInstall
  '';

  meta = kubernetes.meta // {
    description = "Kubernetes CLI";
    homepage = "https://github.com/kubernetes/kubectl";
    platforms = lib.platforms.unix;
  };
}
