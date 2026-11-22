{
  # mockery has historically required changes to support new Go versions, so use the latest
  # version that mockery supports rather than buildGoLatestModule.
  # This should be bumped when a mockery release includes support for a new version of Go.
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
  go-task,
  gotestsum,
}:

buildGo127Module (finalAttrs: {
  pname = "go-mockery_2";
  # supported upstream until 2029-12-31
  # https://vektra.github.io/mockery/latest/v3/#v2-support-lifecycle
  version = "2.53.8";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l8aRTjRvDX871gw1PoapWCZNRhbeDVEJS6heWXmKFew=";
  };

  proxyVendor = true;
  vendorHash = "sha256-8YhkbAh8rHdNzvyiT1rScjOnyAcE5/hgcibCOEm7Cvo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vektra/mockery/v${lib.versions.major finalAttrs.version}/pkg/logging.SemVer=v${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [ "." ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    homepage = "https://github.com/vektra/mockery";
    description = "Mock code autogenerator for Golang - v2";
    maintainers = with lib.maintainers; [
      fbrs
      jk
    ];
    mainProgram = "mockery";
    license = lib.licenses.bsd3;
  };
})
