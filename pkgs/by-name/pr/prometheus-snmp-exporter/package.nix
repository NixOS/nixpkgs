{
  lib,
  buildGoModule,
  fetchFromGitHub,
  net-snmp,
  nixosTests,
}:

buildGoModule rec {
  pname = "snmp_exporter";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "snmp_exporter";
    rev = "v${version}";
    sha256 = "sha256-vLgqcqjnUvXYlxVyybDvra9YY5Im17L4I3LLf77tR8M=";
  };

  vendorHash = "sha256-3Rjt91Xb0Y5OCkwGQVQLZ6zK0+xVk8XNrGfax6zZJ7o=";

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
