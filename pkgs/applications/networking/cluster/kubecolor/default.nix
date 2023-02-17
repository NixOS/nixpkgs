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

  vendorSha256 = "sha256-g5bLi0HQ7LQM+DKn5x8enXn8/9j3LFhgDjQ+YN0M7dM=";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/kubecolor/kubecolor";
    changelog = "https://github.com/kubecolor/kubecolor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ivankovnatsky SuperSandro2000 ];
  };
}
