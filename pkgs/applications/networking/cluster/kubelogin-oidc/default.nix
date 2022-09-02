{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.25.2";

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d3iiUmNEPKylYSFq9cSfgJuQYLPhBJavGV8tOao0l4s=";
  };

  subPackages = ["."];

  vendorSha256 = "sha256-XxVXhNWZOyvrdh2yPQogtH62h7d8NbsNhhrwGuqcLJs=";

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
