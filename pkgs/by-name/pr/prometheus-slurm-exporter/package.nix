{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-slurm-exporter";
  version = "0.24";

  src = fetchFromGitHub {
    owner = "vpenso";
    repo = "prometheus-slurm-exporter";
    tag = finalAttrs.version;
    hash = "sha256-WWAioKaK8qxKgQTxn89rslW8OMvNRuOV6GSWu2XA7w4=";
  };

  vendorHash = "sha256-TCMYaCRR62dBbJD/lZ6vVd0jM0gfJjkjJJaI8lCiND0=";

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
