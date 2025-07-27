{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "metapac";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ripytide";
    repo = "metapac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lJFCJNfxS3yZ4vG3Y4aDDGzDDoQd6bVu1WDHi4jlTm4=";
  };

  cargoHash = "sha256-vkcAiaES49MkbjAn33Mel6w63EgV+HpVaqWYWzYZdAU=";

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
