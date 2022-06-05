{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.144.0";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-mfRPrgnOXqfmbpvaIxJNkgkdTEJKcFycrgFmQ7YDvTU=";
  };

  vendorSha256 = "sha256-ddf3m0DGsjubzp/aERvhfJ51UKKSNMC1Xu7ybyif8HA=";

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
