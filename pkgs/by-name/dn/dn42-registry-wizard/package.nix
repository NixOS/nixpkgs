{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dn42-registry-wizard";
  version = "0.4.21";

  src = fetchFromGitHub {
    owner = "Kioubit";
    repo = "dn42_registry_wizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PvB+rlIaedjCVA/8sDW754vvomVASIDhkUQlimZGiRg=";
  };

  cargoHash = "sha256-tSxxsRQCbbP6iRT8sNfA/JVLm72PsSSCsC80hD5ZVxw=";

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
