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
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "westpoint-io";
    repo = "lazyrsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cM6FBNXSDOcPkAxf8gNtjaHl1mR7tH383zFIQlPj+GE=";
  };

  cargoHash = "sha256-Qzy9N0km9kw+deg2tfFyffnTrLyuPWRS2yqmuX3CZrQ=";

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
