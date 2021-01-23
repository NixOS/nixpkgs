{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-CvepOpAI40eTS5p5gjtbzahn0tX/z4CId1DDqlaMSMw=";
  };

  vendorSha256 = "sha256-VRNQ6TsjM0IgnSyZRzAaf7DO6TZx5KrAWNqq+wuvmhE=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
