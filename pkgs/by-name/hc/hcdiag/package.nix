{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "hcdiag";
  version = "0.5.15";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcdiag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jcdceDDlZCo/F1DI6TYPbNUuHXLTfdu+A2bOC1EYoYg=";
  };

  vendorHash = "sha256-fzznLAm3dpRkAay75VEr2/HCpaqiU/zHIjcmCFinwh0=";

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
