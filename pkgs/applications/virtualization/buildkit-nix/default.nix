{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkit-nix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gKTCBz7om1M7UBzyMJDetNGcKLkQKMyuzwrHBbuuifM=";
  };

  vendorSha256 = "sha256-1H5oWgcaamf+hocABWWnzJUjWiqwk1ZZtbBjF6EKzzU=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Nix frontend for BuildKit";
    homepage = "https://github.com/reproducible-containers/buildkit-nix/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lesuisse ];
  };
}
