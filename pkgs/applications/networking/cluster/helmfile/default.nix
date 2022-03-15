{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "helmfile";
  version = "0.143.1";

  src = fetchFromGitHub {
    owner = "roboll";
    repo = "helmfile";
    rev = "v${version}";
    sha256 = "sha256-eV2+lQVLv+bU/CmFFYM7CLjomXblT0XVZH5HVq0S+WM=";
  };

  vendorSha256 = "sha256-JHXSEOR/+ON5x0iQgaFsnb9hEDFf5/8TTh4T54qE/HE=";

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
