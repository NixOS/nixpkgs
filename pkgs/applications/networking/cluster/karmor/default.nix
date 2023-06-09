{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "karmor";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${version}";
    hash = "sha256-IKvWS1c7u1a3Fm2+uyhhgyuM680ZYiq9Xq2Tg/Y6HJo=";
  };

  vendorHash = "sha256-xBtKKq6oUjazRac1FozRXBNRv1rFXYAulWu0Rs8ETvQ=";

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
