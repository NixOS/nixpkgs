{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mc-monitor";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "mc-monitor";
    tag = finalAttrs.version;
    hash = "sha256-juHtv/6IAueimFul0LdhrWUnomfhhWmiMp2gK0/MfT8=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-kbhQVMu7RZ5R2prQ5yVeIFA/QXl/vRwRdWGNlHkUg3A=";

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
