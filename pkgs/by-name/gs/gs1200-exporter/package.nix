{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:
buildGoModule rec {
  pname = "gs1200-exporter";
  version = "2.11.15";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "robinelfrink";
    repo = "gs1200-exporter";
    tag = "v${version}";
    hash = "sha256-ms4MtY9HzbtPgDtq2cEOsm9s4yrQT57H+/XtRM1fcKc=";
  };

  vendorHash = "sha256-fsDqMM0qV2NFWQ0Ims+6ZXL0TJoOFtBUCMnMK0oFtcs=";

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
