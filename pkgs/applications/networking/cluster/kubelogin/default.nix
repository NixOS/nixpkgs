{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+u+75Z2Efaq16g7kGNq1GHavXwtKvNO6dytniUr8mlE=";
  };

  vendorSha256 = "sha256-vJfTf9gD/qrsPAfJeMYLjGa90mYLOshgDehv2Fcl6xM=";

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
