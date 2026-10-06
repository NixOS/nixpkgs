{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "deja";
  version = "0.4.2";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "Giammarco-Ferranti";
    repo = "deja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9AzqGDZLlv5BxpuuV3JUfJxW5a2ljZakVHnegQgdO+0=";
  };

  vendorHash = "sha256-XHcZUtx82zT3yPCYzJG+a7zfARPW4clbMn77/4luskw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Predictive inline shell autosuggestions for zsh";
    homepage = "https://github.com/Giammarco-Ferranti/deja";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "deja";
  };
})
