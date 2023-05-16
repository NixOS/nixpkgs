<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, testers, eks-node-viewer }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.4.3";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-570wOLUtKKzDDLLDrAOPAnAUpZeAqrwKsQWoHCBjKKk=";
  };

  vendorHash = "sha256-kRRUaA/psQDmcM1ZhzdZE3eyw8DWZpesJVA2zVfORGk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.builtBy=nixpkgs"
    "-X=main.commit=${src.rev}"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = eks-node-viewer;
    };
  };
=======
    sha256 = "sha256-XRt9a//0mYKZKsMs2dlcsBt5ikC9ZBMeQ3Vas0eT8a8=";
  };

  vendorHash = "sha256-28TKZYZM2kddXAusxmjhrKFy+ATU7kZM4Ad7zvP/F3A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to visualize dynamic node usage within a cluster";
    homepage = "https://github.com/awslabs/eks-node-viewer";
<<<<<<< HEAD
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${src.rev}";
    license = licenses.asl20;
=======
    changelog = "https://github.com/awslabs/eks-node-viewer/releases/tag/${version}";
    license = licenses.afl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
