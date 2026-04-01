{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dn42-registry-wizard";
  version = "0.4.19";

  src = fetchFromGitHub {
    owner = "Kioubit";
    repo = "dn42_registry_wizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-axtNkBX0OTm/3HwpZATsAefW/LEFDtTODLJgHJiFws8=";
  };

  cargoHash = "sha256-VfdxsS8VIgDDyhNXML5jVl+9uxwHa83aWB6nJ7mHflI=";

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
