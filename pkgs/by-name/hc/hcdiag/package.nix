{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "hcdiag";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcdiag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OHCxyBA4kCeCwvl8ZM33gLGc19wl7DtZ2gHveNCSAc0=";
  };

  vendorHash = "sha256-otBZVOc0lS9IFk0w8A4gD+0MVEn35h0uk5Ul9eH9lFw=";

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
