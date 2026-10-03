{
  lib,
  buildGoModule,
  fetchFromGitHub,
  osv-detector,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "osv-detector";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "G-Rath";
    repo = "osv-detector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3XKH2CgZeawzmIMQPMGLz9A1ax1L3ynrwpQmvOiHBgo=";
  };

  vendorHash = "sha256-zjoscB0dy9rStDWpGS9XLxvCcIJaa1zNjETxx9hpPYw=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = osv-detector;
    command = "osv-detector -version";
    version = "osv-detector ${finalAttrs.version} (unknown, commit none)";
  };

  meta = {
    description = "Auditing tool for detecting vulnerabilities";
    mainProgram = "osv-detector";
    homepage = "https://github.com/G-Rath/osv-detector";
    changelog = "https://github.com/G-Rath/osv-detector/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
