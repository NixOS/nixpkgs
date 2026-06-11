{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:
buildGoModule rec {
  pname = "gs1200-exporter";
  version = "2.11.12";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "robinelfrink";
    repo = "gs1200-exporter";
    tag = "v${version}";
    hash = "sha256-8s2VgaqYXp9PN2oNU/sWpjQjDPSWolbWEVSZcx9Lh3M=";
  };
  vendorHash = "sha256-204bFaywOolKVNoeH/w72Ba1PYAVgQawEmlaEXgRaRY=";
  passthru.tests = {
    inherit (nixosTests) gs1200-exporter;
  };
  meta = {
    description = "Prometheus exporter for Zyxel GS1200 switches";
    homepage = "https://github.com/robinelfrink/gs1200-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ DerGrumpf ];
    mainProgram = "gs1200-exporter";
  };
}
