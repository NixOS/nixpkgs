{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rsync,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lazyrsync";
  version = "0.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "westpoint-io";
    repo = "lazyrsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JBELPmNSaiwxHq9iZHvvrCX/YLSBsOO3OrzXJ0mPrNw=";
  };

  cargoHash = "sha256-/L6N08TFqwW6yeNFiIUtmz6SxdEuxa6SHMxDoZ4Myl8=";

  nativeCheckInputs = [ rsync ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI for rsync with profiles, dry-run preview and live progress";
    homepage = "https://lazyrsync.westpoint.io";
    changelog = "https://github.com/westpoint-io/lazyrsync/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "lazyrsync";
    maintainers = with lib.maintainers; [ kiryuulight ];
  };
})
