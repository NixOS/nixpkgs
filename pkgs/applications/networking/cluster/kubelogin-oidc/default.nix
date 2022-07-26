{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BKJ6dZMGW+Md+YUEEgWtPdfiFiOP5Nfb+awx8FXB+bM=";
  };

  subPackages = ["."];

  vendorSha256 = "sha256-mu4NHeYZBM4C5qpj2wRTLsRNLDvZGNkppKGDw621mp4=";

  # Rename the binary instead of symlinking to avoid conflict with the
  # Azure version of kubelogin
  postInstall = ''
    mv $out/bin/kubelogin $out/bin/kubectl-oidc_login
  '';

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing OpenID Connect (OIDC) authentication";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
