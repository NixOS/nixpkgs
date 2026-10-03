{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mc-monitor";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "itzg";
    repo = "mc-monitor";
    tag = finalAttrs.version;
    hash = "sha256-aVcP2aHDwy/Z80FchyvLPT2040n97j9YuF8ThJEOsL0=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-TgurVZ+CT0HgNwZTqoQ1dCmrgfMxXYkSAP9xtKzO3js=";

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
