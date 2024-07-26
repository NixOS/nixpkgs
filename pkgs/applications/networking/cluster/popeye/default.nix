{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "popeye";
  version = "0.20.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-e3ANhF2g1YpCipnHej2ZegoAq20MOyTIjxgNMs3qGbk=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/popeye/cmd.version=${version}"
    "-X github.com/derailed/popeye/cmd.commit=${version}"
  ];

  vendorHash = "sha256-lRm3cS+VYP9vptr6ixmkni7DpNnexrhyccKDV7TWKg0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd popeye \
      --bash <($out/bin/popeye completion bash) \
      --fish <($out/bin/popeye completion fish) \
      --zsh <($out/bin/popeye completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/popeye version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "A Kubernetes cluster resource sanitizer";
    homepage = "https://github.com/derailed/popeye";
    changelog = "https://github.com/derailed/popeye/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
