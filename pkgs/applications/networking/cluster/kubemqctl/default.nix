{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubemqctl";
<<<<<<< HEAD
  version = "3.7.2";

=======
  version = "3.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PaB5+Sy2ccEQz+wuz88w/M4NXayKA41/ugSPJdtjfiE=";
  };

  vendorHash = "sha256-rou4IC5wMIq7i/OGAvE28qke0X6C5S7Iw+gwCPf5Zdk=";

  preBuild = ''
    # The go.sum file is missing from the upstream.
    cp ${./go.sum} go.sum
  '';

=======
    sha256 = "0daqvd1y6b87xvnpdl2k0sa91zdmp48r0pgp6dvnb2l44ml8a4z0";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = [ "-w" "-s" "-X main.version=${version}" ];

  doCheck = false; # TODO tests are failing

<<<<<<< HEAD
=======
  vendorSha256 = null; #vendorSha256 = "";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    homepage = "https://github.com/kubemq-io/kubemqctl";
    description = "Kubemqctl is a command line interface (CLI) for Kubemq Kubernetes Message Broker.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
<<<<<<< HEAD
=======
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
