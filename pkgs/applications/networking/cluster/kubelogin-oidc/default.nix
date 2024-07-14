{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sFEFvWizQeQp9VE1guO9xMZl9+cFk6jV43TVCbD8pas=";
  };

  subPackages = ["."];

  vendorHash = "sha256-Mel9fH13iXSpB2kClJsH0SM+/gIzu2rPt2q0fjQwumw=";

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
