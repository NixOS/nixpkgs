{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-klipper-exporter";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "scross01";
    repo = "prometheus-klipper-exporter";
    rev = "v${version}";
    sha256 = "sha256-ow7bzgaY4pYccslITlkNBKfZBJv9uwPk25I1Y3bnjbU=";
  };

  vendorHash = "sha256-0nbLHZ2WMLMK0zKZuUYz355K01Xspn9svmlFCtQjed0=";

  doCheck = true;

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) process;
  };

  meta = with lib; {
    description = " Prometheus Exporter for Klipper ";
    homepage = "https://github.com/scross01/prometheus-klipper-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ wulfsta ];
    platforms = platforms.linux;
  };
}
