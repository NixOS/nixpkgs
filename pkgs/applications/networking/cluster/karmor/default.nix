{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "karmor";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${version}";
    hash = "sha256-BhGe4CMd0YgWc4EAyig5wmLgHJxNc8ppsUMBeRaIJEE=";
  };

  vendorHash = "sha256-VT0CiaG5AODAL6nhoPmpulPApgTUiH0mXI6mS1eK14k=";

  nativeBuildInputs = [ installShellFiles ];

  # integration tests require network access
  doCheck = false;

  postInstall = ''
    mv $out/bin/{kubearmor-client,karmor}
    installShellCompletion --cmd karmor \
      --bash <($out/bin/karmor completion bash) \
      --fish <($out/bin/karmor completion fish) \
      --zsh  <($out/bin/karmor completion zsh)
  '';

  meta = with lib; {
    description = "A client tool to help manage KubeArmor";
    homepage = "https://kubearmor.io";
    changelog = "https://github.com/kubearmor/kubearmor-client/releases/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
