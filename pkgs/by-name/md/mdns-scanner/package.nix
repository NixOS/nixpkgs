{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdns-scanner";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "CramBL";
    repo = "mdns-scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QMUgPY8BwUL0CGv1mFV+KbdGXh/O4hnngCYYVWsGI64=";
  };

  cargoHash = "sha256-esC84lY+EGGQK8N4DWuVs7hZoXYag8NSxDrfybamYJQ=";

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
