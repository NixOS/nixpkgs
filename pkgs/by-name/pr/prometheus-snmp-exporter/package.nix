{
  lib,
  buildGoModule,
  fetchFromGitHub,
  net-snmp,
  nixosTests,
}:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-vpCBDfG5jzxuNUC6iwLiwnP72jLCVGAWFI9jVYbLNAM=";
  };

  vendorHash = "sha256-pt/m/I+cW/JDnfiShYExqcWIb+kBWpxF4c0jAnTVdkY=";

  buildInputs = [ net-snmp ];

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) snmp; };

  meta = {
    description = "SNMP Exporter for Prometheus";
    homepage = "https://github.com/prometheus/snmp_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Frostman
    ];
  };
}
