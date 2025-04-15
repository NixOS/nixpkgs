{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gopls";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    tag = "gopls/v${finalAttrs.version}";
    hash = "sha256-5w6R3kaYwrZyhIYjwLqfflboXT/z3HVpZiowxeUyaWg=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-/tca93Df90/8K1dqhOfUsWSuFoNfg9wdWy3csOtFs6Y=";

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${finalAttrs.version}" ];

  doCheck = false;

  # Only build gopls, gofix, modernize, and not the integration tests or documentation generator.
  subPackages = [
    "."
    "internal/analysis/gofix/cmd/gofix"
    "internal/analysis/modernize/cmd/modernize"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=gopls/(.*)" ]; };

  meta = {
    changelog = "https://github.com/golang/tools/releases/tag/gopls/v${finalAttrs.version}";
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mic92
      rski
      SuperSandro2000
      zimbatm
    ];
    mainProgram = "gopls";
  };
})
