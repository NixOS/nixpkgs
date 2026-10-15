{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  osv-scanner,
}:

buildGoModule (finalAttrs: {
  pname = "osv-scanner";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "osv-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBAGlTz+GED9e4O/tCLuica0YgkGp+AgYKIcMHKJ31s=";
  };

  vendorHash = "sha256-5on5A933JvMfUJZjrMImNvNqGK6u9MsNxl425nv0ktU=";

  subPackages = [
    "cmd/osv-scanner"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/google/osv-scanner/internal/version.OSVVersion=${finalAttrs.version}"
    "-X=main.commit=n/a"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  # Tests require network connectivity to query https://api.osv.dev.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = osv-scanner;
  };

  meta = {
    description = "Vulnerability scanner written in Go which uses the data provided by https://osv.dev";
    mainProgram = "osv-scanner";
    homepage = "https://github.com/google/osv-scanner";
    changelog = "https://github.com/google/osv-scanner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      stehessel
    ];
  };
})
