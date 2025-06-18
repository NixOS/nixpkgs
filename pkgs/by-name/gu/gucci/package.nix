{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gucci,
}:

buildGoModule (finalAttrs: {
  pname = "gucci";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "noqcks";
    repo = "gucci";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CL4Vn3DP40tBBejN28iQSIV+2GtHwl7IS8zVJ5wcqwY=";
  };

  vendorHash = "sha256-+0pq2lbwfvWdAiz7nONrmlRRxS886B+wieoMeuxLUtM=";

  ldflags = [
    "-s"
    "-w"
    "-X main.AppVersion=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = gucci;
  };

  checkFlags = [
    "-short"
    # Integration tests rely on Ginkgo but fail.
    # Related: https://github.com/onsi/ginkgo/issues/602
    #
    # Disable integration tests.
    "-skip=^TestIntegration"
  ];

  meta = {
    description = "Simple CLI templating tool written in golang";
    mainProgram = "gucci";
    homepage = "https://github.com/noqcks/gucci";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ braydenjw ];
  };
})
