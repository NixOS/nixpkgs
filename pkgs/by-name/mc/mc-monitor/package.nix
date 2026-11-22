{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mc-monitor";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "mc-monitor";
    tag = finalAttrs.version;
    hash = "sha256-0BOoCgIP/T0uFZza3VBjS5FxlGQQVx1JIZiRN1Aemp4=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-eH+QGA2lcNGy9RngZr7HYYRP6pcUHJdmKm7SmNUKlJk=";

  # Upstream tests require network access
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Monitor status of Minecraft servers";
    homepage = "https://github.com/itzg/mc-monitor";
    changelog = "https://github.com/itzg/mc-monitor/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shunueda ];
    mainProgram = "mc-monitor";
  };
})
