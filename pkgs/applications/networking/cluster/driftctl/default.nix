{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "driftctl";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "cloudskiff";
    repo = "driftctl";
    rev = "v${version}";
    sha256 = "sha256:1k9mx3yh5qza5rikg38ls78gbi4mw8ar4c1x9ij863w1c28fdzlb";
  };

  vendorSha256 = "sha256:0dajz1xbf607l9y5kby4kh7h28v4b3jjmnjsf6cys46pcgxa0zw3";

  ldflags = [
    "-X github.com/cloudskiff/driftctl/build.enableUsageReporting=false"
    "-X github.com/cloudskiff/driftctl/build.env=release"
    "-X github.com/cloudskiff/driftctl/pkg/version.version=v${version}"
  ];

  meta = with lib; {
    description = "Tool to track infrastructure drift";
    homepage = "https://github.com/cloudskiff/driftctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction ];
  };
}
