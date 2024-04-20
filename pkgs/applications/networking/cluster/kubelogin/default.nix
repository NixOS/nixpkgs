{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mQSQrcLzEZqNpXNuZFCVk3FRcfkrtvN19VhwqyrmwIU=";
  };

  vendorHash = "sha256-Xh4htBknBW59xdJVYw7A7BT2GB5WW8SnV05is7dWAS8=";

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
