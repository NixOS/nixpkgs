{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "metapac";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ripytide";
    repo = "metapac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n+wWCgRyht3XKqka/u1WMTrPOCW2V03gW9YQunr2jrI=";
  };

  cargoHash = "sha256-CThJbRt4k8nIBsSKDYKs3DlWISbkpjP+Jols215UPMw=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A multi-backend declarative package manager";
    longDescription = ''
      metapac allows you to maintain a consistent set of packages
      across multiple machines. It also makes setting up a new system
      with your preferred packages from your preferred package
      managers much easier.
    '';
    homepage = "https://github.com/ripytide/metapac";
    changelog = with finalAttrs; "${meta.homepage}/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "metapac";
  };
})
