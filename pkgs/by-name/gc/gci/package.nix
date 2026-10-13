{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "gci";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = "gci";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+qoHORHUMgr03v3RB+7+g9O/tlDkQKFmKybma0FdhVs=";
  };

  vendorHash = "sha256-MS6Ei58HpR/ueqdmGEx15WoSSSwDpQUcxAWz36UnhmA=";

  excludedPackages = [ "v2" ];

  ldflags = [
    "-s"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "gci";
  };
})
