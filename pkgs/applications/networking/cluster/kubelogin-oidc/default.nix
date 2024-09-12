{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fGCllV07YustUIX1XiSvsC42obDOgl2yV5ruQMT2R0c=";
  };

  subPackages = ["."];

  vendorHash = "sha256-wtxSoRSpmRwuIOdKGmCRR+QLwOvONiiltg6KL6t2cf8=";

  # Rename the binary instead of symlinking to avoid conflict with the
  # Azure version of kubelogin
  postInstall = ''
    mv $out/bin/kubelogin $out/bin/kubectl-oidc_login
  '';

  meta = with lib; {
    description = "Kubernetes credential plugin implementing OpenID Connect (OIDC) authentication";
    mainProgram = "kubectl-oidc_login";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
