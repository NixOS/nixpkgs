{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGo126Module (finalAttrs: {
  pname = "ku";
  version = "0.7.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "ku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KaD2DUPkkCT5vG6nNOL/TGXUK6Q/KErZhhE2Zb/D78s=";
  };

  vendorHash = "sha256-0gLwvJSEMgCw23YG8rMzoI7ubo0I5nvguex2HBJE1dU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, keyboard-driven Kubernetes TUI";
    homepage = "https://github.com/bjarneo/ku";
    changelog = "https://github.com/bjarneo/ku/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevinpita ];
    mainProgram = "ku";
    platforms = lib.platforms.unix;
  };
})
