{ lib,
  fetchFromGitHub,
  buildGoModule
}:

buildGoModule rec {
  pname = "hacompanion";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "tobias-kuendig";
    repo = "hacompanion";
    rev = "v${version}";
    hash = "sha256-FR2IowbaHXr9x/eMt+NCuGusMwX2iVxPOuWEkhH2GFM=";
  };

  vendorHash = "sha256-ZZ8nxN+zUeFhSXyoHLMgzeFllnIkKdoVnbVK5KjrLEQ=";

  meta = {
    changelog = "https://github.com/tobias-kuendig/hacompanion/releases/tag/v${version}";
    description = "Daemon that sends local hardware information to Home Assistant";
    homepage = "https://github.com/tobias-kuendig/hacompanion";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ramblurr ];
  };
}
