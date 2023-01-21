{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "karmor";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${version}";
    hash = "sha256-xVYhZT4yqbSmxGH5DaarXzrGYMS1BuTaQ2T+huWYLBw=";
  };

  vendorHash = "sha256-rlvAQ99/3+3VotyYAR2TgWG8ZdTKUT2XRv4hTF+QFpI=";

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
