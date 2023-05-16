{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecolor";
  version = "0.0.21";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d1gtbpeK9vp8bwhsMOPVKmohfyEZtQuvRB36VZCB3sY=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-g5bLi0HQ7LQM+DKn5x8enXn8/9j3LFhgDjQ+YN0M7dM=";
=======
  vendorSha256 = "sha256-g5bLi0HQ7LQM+DKn5x8enXn8/9j3LFhgDjQ+YN0M7dM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky SuperSandro2000 ];
  };
}
