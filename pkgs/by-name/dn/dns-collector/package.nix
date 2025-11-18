{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "dns-collector";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "dns-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oip7rMCcWppUwCPy6VG/kJsNWf1EZZmf0iTj8FSvHeE=";
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

  vendorHash = "sha256-1gFsLsPrsJhZ6V3/H22ZjIHrG1hTsRCj/Ur3gC01NSE=";

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
