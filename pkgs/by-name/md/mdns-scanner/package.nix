{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdns-scanner";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CramBL";
    repo = "mdns-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qPeqNM02m18Z8eI/Y3pqHGomWZhFUmOetWmpEXaIjpk=";
  };

  cargoHash = "sha256-I+6ivhTfVR8xSCFVndsylk/LxTuCNeBfILvyo+6pk70=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/CramBL/mdns-scanner";
    description = "Scan a network and create a list of IPs and associated hostnames, including mDNS hostnames and other aliases";
    changelog = "https://github.com/CramBL/mdns-scanner/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "mdns-scanner";
  };
})
