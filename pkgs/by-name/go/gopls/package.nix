{
  lib,
  # gopls breaks if it is compiled with a lower version than the one it is running against.
  # This will affect users especially when project they work on bump go minor version before
  # the update went through nixpkgs staging. Further, gopls is a central ecosystem component.
  buildGoLatestModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoLatestModule (finalAttrs: {
  pname = "gopls";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    tag = "gopls/v${finalAttrs.version}";
    hash = "sha256-QJnLJNgFtc/MmJ5WWooKcavnPPTYuM4XhUHcbwlvMLY=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-P5wUGXmVvaRUpzmv/SPX8OpCXOCOg6nBI544puNOWCE=";

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${finalAttrs.version}" ];

  doCheck = false;

  # Only build gopls & modernize, not the integration tests or documentation generator.
  subPackages = [
    "."
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
