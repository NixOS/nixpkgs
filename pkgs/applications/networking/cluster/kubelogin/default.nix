{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j6koBf+8mF5k27H/N/UriTSkRstrdA2zrvU9KqP/l5U=";
  };

  vendorHash = "sha256-GMTNcZ2jN+014Ivltcf00/UDYDu464fce36Zfg07/Yo=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [];
  };
}
