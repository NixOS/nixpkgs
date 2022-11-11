{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZaAjXuECOmGIqye08/A41VQiO7avxqbaCOPFCPjaOjY=";
  };

  vendorSha256 = "sha256-3TQm0xbgFDZ2XCie93g4fPXKCHDh/yw4vwpAEMBMQGI=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
