{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  kubectl,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubecolor";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kubecolor";
    repo = "kubecolor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1eLt75w/l6AQDDUMhKIvWnaQox87r5M3c30AtpNyZFw=";
  };

  vendorHash = "sha256-oTeDByJ81eWCCsIHyuScQS+lhE9cHqiATIlw2UdUZNo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "."
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # kubecolor re-uses the completions of kubectl for its own executable

    installShellCompletion --cmd kubecolor \
      --bash <(${lib.getExe kubectl} completion bash) \
      --fish <(${lib.getExe kubectl} completion fish) \
      --zsh <(${lib.getExe kubectl} completion zsh)

    # https://kubecolor.github.io/setup/shells/bash/
    echo 'complete -o default -F __start_kubectl kubecolor' >> $out/share/bash-completion/completions/kubecolor.bash

    # https://kubecolor.github.io/setup/shells/fish/
    echo -e 'function kubecolor --wraps kubectl\n  command kubecolor $argv\nend' >> $out/share/fish/vendor_completions.d/kubecolor.fish

    # https://kubecolor.github.io/setup/shells/zsh/
    echo 'compdef kubecolor=kubectl' >> $out/share/zsh/site-functions/_kubecolor
  '';

  meta = {
    description = "Colorizes kubectl output";
    mainProgram = "kubecolor";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      SuperSandro2000
      applejag
    ];
  };
})
