{
  lib,
  python3,
  fetchPypi,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prometheus_pve_exporter";
  version = "3.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9D2obD3Bxmhh7x7HL/asV1Wo6WBotkdP4F4RXuIwV1k=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    prometheus-client
    proxmoxer
    pyyaml
    requests
    werkzeug
    gunicorn
    wrapt
  ];

  doCheck = false;

  pythonImportsCheck = [ "pve_exporter" ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) pve;
  };

  meta = {
    description = "Exposes information gathered from Proxmox VE cluster for use by the Prometheus monitoring system";
    mainProgram = "pve_exporter";
    homepage = "https://github.com/prometheus-pve/prometheus-pve-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nukaduka ];
  };
}
