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
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "westpoint-io";
    repo = "lazyrsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GKTHohpA9h+uqJS2dwgjMmGfl3KRbmE9Jt94YbprVKE=";
  };

  cargoHash = "sha256-OE7TCcPRDqbtVXN/VDO4HckM6woV/0gzfNr8Di+m1Oo=";

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
