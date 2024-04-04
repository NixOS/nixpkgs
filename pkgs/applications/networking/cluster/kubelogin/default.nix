{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JBP2lE1/46VB/oKgDlNTQ8RFpgIlQE0If5vND7dzo7A=";
  };

  vendorHash = "sha256-EwL/aiq2jyojM1r7wNZkA07TswHy6MLUUPQJFnaDG4A=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    mainProgram = "kubelogin";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [];
  };
}
