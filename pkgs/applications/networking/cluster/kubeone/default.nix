{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubeone";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
    sha256 = "sha256-2+67ctiFkEV4UU7vcF/s+qJWDpdzSRaiy9pa9zt+ccA=";
  };

  vendorSha256 = "sha256-kI5i1us3Ooh603HOz9Y+HlfPUy/1J8z89/jvKEenpLw=";

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
