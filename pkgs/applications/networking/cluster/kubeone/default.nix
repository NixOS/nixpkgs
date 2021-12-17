{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    sha256 = "sha256-Y0IlTOAfwEp8WkFpXSS02vEhCM4+juAY+Nx/e9Vv0F0=";
  };

  vendorSha256 = "sha256-/rhV7JHuqejCTizcjKIkaJlbRcx7AfMcGqQYo6dlg48=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  meta = {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments.";
    homepage = "https://kubeone.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lblasc ];
  };
}
