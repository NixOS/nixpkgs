{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "gitlab-container-registry";
  version = "3.66.0";
  rev = "v${version}-gitlab";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "container-registry";
    inherit rev;
    sha256 = "sha256-R2z8T6NYmzQavgzYCZjtJIbIjJJWx7keonXdI/fn7fo=";
  };

  vendorHash = "sha256-hQqnLew6BoLmrpCghreCmCqlfbppV+z5PXj+Q/3MTmY=";

  # Tests rely on network connectivity
  #
  # --- FAIL: TestHTTPChecker (0.00s)
  #     checks_test.go:23: Google at Portugal was expected as exists, error:error while checking: https://www.google.pt
  # FAIL
  # FAIL    github.com/docker/distribution/health/checks    0.003s
  #
  doCheck = false;

  meta = with lib; {
    description = "The GitLab Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [ maintainers.xanderio ];
    platforms = platforms.unix;
  };
}
