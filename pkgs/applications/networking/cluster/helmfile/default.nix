{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.142.0";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-kz5U9MPpN+14Eb1D1hjwDfvTOygzg0unyIgrFTFhE0Q=";
  };

  vendorSha256 = "sha256-HKHMeDnIDmQ7AjuS2lYCMphTHGD1JgQuBYDJe2+PEk4=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/roboll/helmfile/pkg/app/version.Version=${version}" ];

  meta = {
    description = "Deploy Kubernetes Helm charts";
    homepage = "https://github.com/roboll/helmfile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pneumaticat yurrriq ];
    platforms = lib.platforms.unix;
  };
}
