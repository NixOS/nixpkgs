{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotip";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "gotip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z5Xk+lTDAvkMOJAR6eIC6rg+CP9wv+CSANdgj+KmPjA=";
  };

  vendorHash = "sha256-AgyFhoyPyXN5ngTi8iKzbx0wOqlu64gFdrygPOFHZT4=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactively pick and run Go tests";
    homepage = "https://github.com/lusingander/gotip";
    changelog = "https://github.com/lusingander/gotip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gotip";
  };
})
