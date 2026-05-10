{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdns-scanner";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "CramBL";
    repo = "mdns-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-90+VBCxb4bbmGCpBLmqzhUJ0/9GAH8Fnju61kq7sx+A=";
  };

  cargoHash = "sha256-LTL5nlT75Y/cALKVLVBWlMZZn9DewZfCbTAO1QsAfXI=";

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
