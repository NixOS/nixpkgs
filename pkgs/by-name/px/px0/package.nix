{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "px0";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "px0-ai";
    repo = "px0";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1r000izgL1EFsBpIkyb8u6+RVhV58qHf+AshSYtINmY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  vendorHash = "sha256-71+6I0u3en/Aw3PVMXx6dF+NQtCiE1T+kd7MENCKnlk=";

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip"
    "TestListenPortFallback|TestTelemetrySessionLifecycle"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, ultra-light, remote-first IDE for code navigation and review in your browser";
    homepage = "https://github.com/px0-ai/px0";
    changelog = "https://github.com/px0-ai/px0/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = "px0";
  };
})
