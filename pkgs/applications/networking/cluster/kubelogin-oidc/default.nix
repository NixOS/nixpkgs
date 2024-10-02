{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DHg46t0gMypK6Nj428gpOMtPuA+XcW4IJU39CHTVGPw=";
  };

  subPackages = ["."];

  vendorHash = "sha256-gr+SsC7MiLj/MZ8kca5Hcfge+7Pm4y963TfwyKHEhBY=";

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
