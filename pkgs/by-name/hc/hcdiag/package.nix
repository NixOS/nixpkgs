{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "hcdiag";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcdiag";
    tag = "v${version}";
    hash = "sha256-ZzSGBw7DRh/VSDtXoMgJpGWVmJUF2G2yZaae+fKklMc=";
  };

  vendorHash = "sha256-MJg6mqG1bn941LqIr0TQhcgWBCwUtfujdpqf4rgCrWM=";

  nativeInstallCheckHooks = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Collects and bundles product and platform diagnostics supporting Consul, Nomad, TFE, and Vault";
    homepage = "https://github.com/hashicorp/hcdiag";
    changelog = "https://github.com/hashicorp/hcdiag/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "hcdiag";
  };
}
