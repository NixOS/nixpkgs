{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  autoAddDriverRunpath,
  dcgm,
}:
buildGo127Module rec {
  pname = "dcgm-exporter";

  version = "4.8.4"; # N.B: If you change this, update dcgm as well to the matching version.

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "dcgm-exporter";
    tag = version;
    hash = "sha256-xyOWhORqdUeWnEXDlTLsAuWEPb3q9+ioGJObwysJFBk=";
  };

  env.CGO_LDFLAGS = "-ldcgm";

  ldflags = [ "-X main.BuildVersion=${version}" ];

  buildInputs = [
    dcgm
  ];

  # gonvml and go-dcgm do not work with ELF BIND_NOW hardening because not all
  # symbols are available on startup.
  hardeningDisable = [ "bindnow" ];

  vendorHash = "sha256-rAfObalba7d4euXDX407PfKASuxNQT2dBr2rg7BsmZo=";

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  # Tests try to interact with running DCGM service.
  doCheck = false;

  # Ship the upstream metric-counter CSVs (--collectors) alongside the binary.
  # See https://github.com/NVIDIA/dcgm-exporter/issues/684.
  postInstall = ''
    install -Dm444 -t "$out/share/dcgm-exporter" \
      etc/default-counters.csv \
      etc/dcp-metrics-included.csv \
      etc/1.x-compatibility-metrics.csv
  '';

  postFixup = ''
    patchelf --add-needed libnvidia-ml.so "$out/bin/dcgm-exporter"
  '';

  meta = {
    description = "NVIDIA GPU metrics exporter for Prometheus leveraging DCGM";
    homepage = "https://github.com/NVIDIA/dcgm-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
    mainProgram = "dcgm-exporter";
    platforms = lib.platforms.linux;
  };
}
