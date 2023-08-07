{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yIRiIZKq+Q10Uo/9qEToeMHMipA5rApkxIRr/IJ0yfY=";
  };

  vendorHash = "sha256-XHSVLATWKklg1jWL4Lnaey7hCkYHAk/cNyUgQZ6WIq0=";

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
