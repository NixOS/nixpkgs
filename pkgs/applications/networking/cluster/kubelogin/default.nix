{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.28";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uIWlOVZIqwOSvFWRIWKTFEp0aToIBo1htUXb3F+njyI=";
  };

  vendorHash = "sha256-CVBpBb8yYkc6/yLPsCPbVhBHecqZ03WE0NcKiH8SGYs=";

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
