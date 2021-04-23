{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kube-score";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "zegl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TYsuSPWTiIlPscul/QO59+lt6sbjJdt7pJuJYO5R9Tc=";
  };

  vendorSha256 = "sha256-ob7mNheyeTcDWml4gi1SD3Pq+oWtJeySIUg2ZrCj0y0=";

  meta = with lib; {
    description = "Kubernetes object analysis with recommendations for improved reliability and security";
    homepage    = "https://github.com/zegl/kube-score";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
