{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "dns-collector";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "dns-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d6FFxVGolXfZF4Ulklxg8u26DdV9yHeDUf2IEEryELw=";
  };
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.BuildDate=1970-01-01T00:00:00Z"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.Revision=${finalAttrs.src.rev}"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-4gk7LwRDrTiMCrR6JJpdSvCmNa7wQ5Hk06OGd6/SACc=";

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "-version";

  meta = {
    changelog = "https://github.com/dmachart/dns-collector/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/dmachart/dns-collector";
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata. ";
    license = lib.licenses.mit;
    mainProgram = "go-dnscollector";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
