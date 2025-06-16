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
    rev = finalAttrs.version;
    hash = "sha256-KS9LoDuLQFq3KoKpHd8vg1jw20YCNRJNJrnBnu5vxvs=";
  };

  vendorHash = "sha256-A1dd9T9SIEHDCiVT2UwV6T02BSLh9ej6LC/2l54hgwI=";

  # Fails to find sinfo during test
  doCheck = false;

  subPackages = [ "." ];

  meta = {
    description = "Prometheus exporter for performance metrics from Slurm";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "prometheus-slurm-exporter";
  };
})
