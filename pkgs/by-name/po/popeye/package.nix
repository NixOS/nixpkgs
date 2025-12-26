{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "popeye";
  version = "0.22.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-CbVYQIE7kjUah+SDEjs5Qz+n4+f3HriQNxYPqDcdr/I=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/derailed/popeye/cmd.version=${version}"
    "-X github.com/derailed/popeye/cmd.commit=${version}"
  ];

  vendorHash = "sha256-Xhn1iOqzCY8fW2lODXwqY4XQZTAPWXaZ0XM5j02bnCs=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd popeye \
      --bash <($out/bin/popeye completion bash) \
      --fish <($out/bin/popeye completion fish) \
      --zsh <($out/bin/popeye completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/popeye version | grep ${version} > /dev/null
  '';

  meta = {
    description = "Kubernetes cluster resource sanitizer";
    mainProgram = "popeye";
    homepage = "https://github.com/derailed/popeye";
    changelog = "https://github.com/derailed/popeye/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
