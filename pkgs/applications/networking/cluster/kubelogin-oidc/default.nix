{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubelogin";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "int128";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A8J381KNhQbWZ+68P8+1xj/lEEc/+YiJ80LqRQatdFQ=";
  };

  subPackages = ["."];

  vendorSha256 = "sha256-V+O3yFxGJTcFETD2qYOurQUbME5NvRNQTr43OkxXFFE=";

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
