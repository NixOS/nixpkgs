{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "kuttl";
  version = "0.11.0";
  cli = "kubectl-kuttl";

  src = fetchFromGitHub {
    owner  = "kudobuilder";
    repo   = "kuttl";
    rev    = "v${version}";
    sha256 = "sha256-42acx1UcvuzDZX2A33zExhhdNqWGkN0i6FR/Kx76WVM=";
  };

  vendorSha256 = "sha256-TUNFUI7Lj7twJhM3bIdL6ElygIVFOlRut1MoFwVRGeo=";

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
