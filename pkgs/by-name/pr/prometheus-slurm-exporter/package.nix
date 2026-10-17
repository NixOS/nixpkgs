{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-slurm-exporter";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "vpenso";
    repo = "prometheus-slurm-exporter";
    tag = finalAttrs.version;
    hash = "sha256-KS9LoDuLQFq3KoKpHd8vg1jw20YCNRJNJrnBnu5vxvs=";
  };

  vendorHash = "sha256-A1dd9T9SIEHDCiVT2UwV6T02BSLh9ej6LC/2l54hgwI=";

  # Needs a working slurm environment during test
  doCheck = false;

  meta = {
    description = "Prometheus exporter for performance metrics from Slurm";
    homepage = "https://github.com/vpenso/prometheus-slurm-exporter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "prometheus-slurm-exporter";
  };
})
