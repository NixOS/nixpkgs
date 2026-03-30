{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  stackql,
}:

buildGoModule (finalAttrs: {
  pname = "stackql";
  version = "0.10.383";

  src = fetchFromGitHub {
    owner = "stackql";
    repo = "stackql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ISbK7O3nupV0BgpneuI3B5xPxGDzwMaNy8wFgZPGKtE=";
  };

  vendorHash = "sha256-xIiBkearGbIUVHs1G+DSvf2y4qjHI5dU37GwapMTtRk=";

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
