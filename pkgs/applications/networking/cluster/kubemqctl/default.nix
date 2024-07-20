{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemqctl";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PaB5+Sy2ccEQz+wuz88w/M4NXayKA41/ugSPJdtjfiE=";
  };

  vendorHash = "sha256-rou4IC5wMIq7i/OGAvE28qke0X6C5S7Iw+gwCPf5Zdk=";

  preBuild = ''
    # The go.sum file is missing from the upstream.
    cp ${./go.sum} go.sum
  '';

  ldflags = [ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false; # TODO tests are failing

  meta = {
    homepage = "https://github.com/kubemq-io/kubemqctl";
    description = "Kubemqctl is a command line interface (CLI) for Kubemq Kubernetes Message Broker";
    mainProgram = "kubemqctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
}
