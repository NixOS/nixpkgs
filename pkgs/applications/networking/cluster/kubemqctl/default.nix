{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemqctl";
  version = "3.5.1";
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "0daqvd1y6b87xvnpdl2k0sa91zdmp48r0pgp6dvnb2l44ml8a4z0";
  };

  ldflags = [ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false; # TODO tests are failing

  vendorSha256 = "1agn6i7cnsb5igvvbjzlaa5fgssr5h7h25y440q44bk16jxk6s74";

  meta = {
    homepage = "https://github.com/kubemq-io/kubemqctl";
    description = "Kubemqctl is a command line interface (CLI) for Kubemq Kubernetes Message Broker.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
}
