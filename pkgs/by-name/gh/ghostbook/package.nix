{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ghostbook";
  version = "0.1.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wjkoh";
    repo = "ghostbook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hZ/Z2xVqrpqH2DZJmDmGCoMnlUcGIBdbcspzSXMh380=";
  };

  vendorHash = "sha256-lUYKdJoSX5+PzJpYpnG1ZAn1pnPoqGWpNChs6oEWGVQ=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [ git ];

  checkFlags = [
    "-skip=TestBrowserEndToEnd|TestDemoVisualAudit"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Single-binary Git-backed collaborative living book where only AI agents write";
    homepage = "https://github.com/wjkoh/ghostbook";
    changelog = "https://github.com/wjkoh/ghostbook/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wjkoh ];
    mainProgram = "ghostbook";
  };
})
