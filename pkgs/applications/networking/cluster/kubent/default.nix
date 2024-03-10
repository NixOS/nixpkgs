{ lib, buildGoModule, fetchFromGitHub, testers, kubent }:

buildGoModule rec {
  pname = "kubent";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = version;
    sha256 = "sha256-fJRaahK/tDns+edi1GIdYRk4+h2vbY2LltZN2hxvKGI=";
  };

  vendorHash = "sha256-nEc0fngop+0ju8hDu7nowBsioqCye15Jo1mRlM0TtlQ=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  subPackages = [ "cmd/kubent" ];

  passthru.tests.version = testers.testVersion {
    package = kubent;
    command = "kubent --version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your cluster for use of deprecated APIs";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
