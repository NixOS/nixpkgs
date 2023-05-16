{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-gadget";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "inspektor-gadget";
    repo = "inspektor-gadget";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-5FbjD02HsMChaMMvTjsB/hzivO4s1H5tLK1QMIMlBCI=";
  };

  vendorHash = "sha256-Beas+oXcK5i4ibE5EAa9+avYuax/kr3op1xbtMPJMas=";
=======
    hash = "sha256:0ijqnlh234pqkx6yzz2kxdnj8hnqarp2scq7gfsp8wpq7s42ivg8";
  };

  vendorHash = "sha256-IbqE0aI7utYuu1XpQijEFVu/IpUDK6CQLu7g8GUR4e8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
    "-extldflags=-static"
  ];

  tags = [
    "withoutebpf"
  ];

  subPackages = [ "cmd/kubectl-gadget" ];

  meta = with lib; {
    description = "A collection of gadgets for troubleshooting Kubernetes applications using eBPF";
    homepage = "https://inspektor-gadget.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ kranurag7 ];
  };
}
