{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helm-docs";
<<<<<<< HEAD
  version = "1.11.1";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "norwoodj";
    repo = "helm-docs";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4o3hdqaW/AtegKStMKVerE3dRr3iZxQ+Lm2Aj3aOy98=";
  };

  vendorHash = "sha256-6byD8FdeqdRDNUZFZ7FUUdyTuFOO8s3rb6YPGKdwLB8=";
=======
    sha256 = "sha256-476ZhjRwHlNJFkHzY8qQ7WbAUUpFNSoxXLGX9esDA/E=";
  };

  vendorSha256 = "sha256-xXwunk9rmzZEtqmSo8biuXnAjPp7fqWdQ+Kt9+Di9N8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/helm-docs" ];
  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/norwoodj/helm-docs";
    description = "A tool for automatically generating markdown documentation for Helm charts";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
