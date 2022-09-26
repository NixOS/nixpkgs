{ buildEnv
, callPackage
, kubectl
, kubernetes
, lib
, makeWrapper
, runCommand
}:

kubernetes.overrideAttrs (_: rec {
  pname = "kubectl";

  outputs = [ "out" "man" "convert" ];

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

  passthru =
    let krewPlugins = callPackage ./krew-plugins.nix { };
    in
    {
      withKrewPlugins = selectPlugins:
        let
          selectedPlugins = selectPlugins krewPlugins;
          kubectlWrapper = runCommand "kubectl-with-plugins-wrapper"
            {
              nativeBuildInputs = [ makeWrapper ];
              meta.priority = kubectl.meta.priority or 0 + 1;
            } ''
            makeWrapper ${kubectl}/bin/kubectl $out/bin/kubectl \
              --prefix PATH : ${lib.makeBinPath selectedPlugins}
          '';
        in
        buildEnv {
          name = "${kubectl.name}-with-plugins";
          paths = [ kubectlWrapper kubectl ];
        };
      inherit krewPlugins;
    };
})
