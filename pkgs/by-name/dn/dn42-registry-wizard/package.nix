{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dn42-registry-wizard";
  version = "0.4.20";

  src = fetchFromGitHub {
    owner = "Kioubit";
    repo = "dn42_registry_wizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WFU1K0Ib1ETSib2WJkwus3zHYJXoVOtFDqv4/QNiP7E=";
  };

  cargoHash = "sha256-o8MF6uqk8f0Zc2fjBqLGElh56TKjLRRtNxrll5nY+bM=";

  postInstall = ''
    mv $out/bin/{registry_wizard,dn42-registry-wizard}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of tools to interact with DN42 registry data";
    homepage = "https://github.com/Kioubit/dn42_registry_wizard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "dn42-registry-wizard";
  };
})
