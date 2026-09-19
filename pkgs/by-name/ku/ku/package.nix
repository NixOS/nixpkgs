{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGo126Module (finalAttrs: {
  pname = "ku";
  version = "0.12.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bjarneo";
    repo = "ku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pdwfNP9RnD4LQKYJ315wrhiRdQN9i/KZ/13jMNlKzvw=";
  };

  vendorHash = "sha256-x7O2/uKnIIFDr8WK0ej3FJiIGxN5Fq5Czqrv4OJ5A44=";

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
