{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  name = "kuttl";
  pname = "kuttl";
  version = "0.9.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner  = "kudobuilder";
    repo   = "kuttl";
    rev    = "v${version}";
    sha256 = "sha256:1cji0py2340mvcpplwq3licdkzjx7q5f27fdjjxvbhrgksnyw6hs";
  };

  vendorSha256 = "sha256:1shra42ifa2knxp58fj5hn074jg89f3nqdqk4rqbp3ybir84ahsd";

  subPackages = [ "cmd/kubectl-kuttl" ];

  buildFlagsArray = ''
    -ldflags=-s -w
    -X  github.com/kudobuilder/kuttl/pkg/version.gitVersion=${version}
  '';

  meta = with lib; {
    description = "The KUbernetes Test TooL (KUTTL) provides a declarative approach to testing production-grade Kubernetes operators";
    homepage = "https://github.com/kudobuilder/kuttl";
    license = licenses.asl20;
    maintainers = with maintainers; [ diegolelis ];
  };
}
