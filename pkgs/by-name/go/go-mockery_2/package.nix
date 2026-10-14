{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  go-task,
  gotestsum,
  getent,
}:

buildGoModule (finalAttrs: {
  pname = "go-mockery_2";
  # supported upstream until 2029-12-31
  # https://vektra.github.io/mockery/latest/v3/#v2-support-lifecycle
  version = "2.53.7";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fPFtPerdgb+7DiRPJUcH/O2jQzyU24D0XlrLlHNneMc=";
  };

  proxyVendor = true;
  vendorHash = "sha256-D3vTsd5FaEQ7/AuKG2Q54nE+Di05ZHHpiqyyStZCFNU=";

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
