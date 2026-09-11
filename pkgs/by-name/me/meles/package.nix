{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "meles";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "movray";
    repo = "meles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DIHK+JtzAZTJyTg5OrHVgd48qv9Z95DvK2p8jBQHvUg=";
  };

  vendorHash = "sha256-4YtBSkpZq5gTbaiV1te7WVyHWLRibK7e4YZAoNlHUaY=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Malware scanner for container images: daemonless, layer-aware, ClamAV and YARA";
    homepage = "https://github.com/movray/meles";
    changelog = "https://github.com/movray/meles/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "meles";
  };
})
