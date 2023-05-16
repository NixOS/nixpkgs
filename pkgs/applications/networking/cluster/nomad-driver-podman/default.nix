{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nomad-driver-podman";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-MYqsTuMLxbVNWLAWjQ8xQts5qJvhTylle7YLtGyswjY=";
  };

  vendorHash = "sha256-wjJ+mq/m7IjbwypoBvBhjOyAT4v4HDSChHY5OE0xA2U=";
=======
    sha256 = "sha256-qHhdjWc9bxUpHYUFUrupjtxxIVQDP43OeKKsCDa+4/M=";
  };

  vendorHash = "sha256-UIUavFdBuSiaUsNaibPjRMURMLLK5UjNHVoyNSIRNQ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
