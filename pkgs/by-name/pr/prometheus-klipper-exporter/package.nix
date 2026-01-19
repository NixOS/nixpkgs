{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-klipper-exporter";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "scross01";
    repo = "prometheus-klipper-exporter";
    rev = "v${version}";
    sha256 = "sha256-zNRjD2YO7OfcNXF5pukXChxhC5LB88C1EKfiMreMzTs=";
  };

  vendorHash = "sha256-0nbLHZ2WMLMK0zKZuUYz355K01Xspn9svmlFCtQjed0=";

  doCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests.prometheus-exporters) process;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Prometheus Exporter for Klipper";
    homepage = "https://github.com/scross01/prometheus-klipper-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wulfsta ];
    platforms = lib.platforms.linux;
  };
}
