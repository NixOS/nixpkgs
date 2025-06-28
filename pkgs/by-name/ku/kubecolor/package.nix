{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  kubectl,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kubecolor";
    repo = "kubecolor";
    rev = "v${version}";
    sha256 = "sha256-FyHTceFpB3Osj8SUw+IRk+JWnoREVZgl8YHczDyY+Ak=";
  };

  vendorHash = "sha256-eF0NcymLmRsFetkI67ZVUfOcIYtht0iYFcPIy2CWr+M=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
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
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      SuperSandro2000
      applejag
    ];
  };
}
