{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  stackql,
}:

buildGoModule (finalAttrs: {
  pname = "stackql";
  version = "0.10.426";

  src = fetchFromGitHub {
    owner = "stackql";
    repo = "stackql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P/TvqCN2nM8j+41bc1bYCN4sYwkhPlNmsoNuYYNI2Mw=";
  };

  vendorHash = "sha256-go1i5xFt3AE+K37+uZz9sjjsgD521fZ7/nPu26531Q8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=${builtins.elemAt (lib.splitVersion finalAttrs.version) 0}"
    "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=${builtins.elemAt (lib.splitVersion finalAttrs.version) 1}"
    "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=${builtins.elemAt (lib.splitVersion finalAttrs.version) 2}"
    "-X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=2026-01-14T07:36:20Z" # date of commit hash
    "-X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true"
  ];

  __darwinAllowLocalNetworking = true;

  checkFlags = [ "--tags json1,sqleanal" ];

  passthru.tests.version = testers.testVersion {
    package = stackql;
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/stackql/stackql";
    description = "Deploy, manage and query cloud resources and interact with APIs using SQL";
    mainProgram = "stackql";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonochang ];
  };
})
