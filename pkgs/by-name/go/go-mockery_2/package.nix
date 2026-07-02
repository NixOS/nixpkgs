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
  version = "2.53.6";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XJnxs+towKaW64TUvmgVsxtYYak6e5qc4u9EKuyHLSs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-BY/Z8xDWPbccwvAf0t71qkxFDI3JqEr7lIxctEzudQ0=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vektra/mockery/v${lib.versions.major finalAttrs.version}/pkg/logging.SemVer=v${finalAttrs.version}"
  ];

  env.CGO_ENABLED = false;

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
