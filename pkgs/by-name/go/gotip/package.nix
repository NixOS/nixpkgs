{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotip";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "gotip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4N6O7cAUIFytjHIqbe7qSmuPHIpyhecw7bLyIP/LRU=";
  };

  vendorHash = "sha256-fQ/rx7gyBcQ3nE/eiCJgtjZCa50iZAuodIZjaRG/mjE=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go test interactive picker";
    homepage = "https://github.com/lusingander/gotip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gotip";
  };
})
