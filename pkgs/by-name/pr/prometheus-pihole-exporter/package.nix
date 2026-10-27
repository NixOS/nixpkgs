{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = "pihole-exporter";
    rev = "v${version}";
    sha256 = "sha256-BCYO84Vf+A4utHh45LkbPleUhHrqp/EVa+8NbVELSBs=";
  };

  vendorHash = "sha256-ueaKB0n2Q4J0XR/7JVvfUC1zAiDgSXyyDeCymEaERCA=";

  meta = {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
