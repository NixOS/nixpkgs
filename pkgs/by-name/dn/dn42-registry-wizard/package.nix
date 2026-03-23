{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dn42-registry-wizard";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "Kioubit";
    repo = "dn42_registry_wizard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wczsDKHcf/izEhJp9THL9yoEfZHTZ0FoVU4CTxmNuAY=";
  };

  cargoHash = "sha256-Op0xjblw3fB1boRaYoVH9O+c2Zodi/TtJ6sQSiz/rLo=";

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
