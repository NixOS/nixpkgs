{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "hcdiag";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcdiag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uJjgQG4ce73/yT2b0lfx9L2Z2Jy93d/uAIs3aTxmjms=";
  };

  vendorHash = "sha256-mUqXnUAnN052RMsMtiUpOTlDVb59Xh3+++E/BtEEQGk=";

  nativeInstallCheckHooks = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Collects and bundles product and platform diagnostics supporting Consul, Nomad, TFE, and Vault";
    homepage = "https://github.com/hashicorp/hcdiag";
    changelog = "https://github.com/hashicorp/hcdiag/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "hcdiag";
  };
})
