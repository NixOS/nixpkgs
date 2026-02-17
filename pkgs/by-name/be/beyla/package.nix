{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libbpf,
  elfutils,
  zlib,
  pkg-config,
}:
buildGoModule (finalAttrs: {
  pname = "beyla";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "beyla";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JX2zUZHLZEdOyMDpPjWg66tjMQdC6lXWAQuifI0TTSY=";
    fetchSubmodules = true;
  };

  vendorHash = null;

  subPackages = ["cmd/beyla"];

  nativeBuildInputs = [pkg-config];

  buildInputs = [
    libbpf
    elfutils
    zlib
  ];

  env.CGO_ENABLED = "1";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require kernel with eBPF enabled
  doCheck = false;

  meta = {
    description = "eBPF-based auto-instrumentation for OpenTelemetry and Prometheus";
    longDescription = ''
      Beyla is a vendor agnostic, eBPF-based, OpenTelemetry/Prometheus application
      auto-instrumentation tool. eBPF is used to automatically inspect application
      executables and the OS networking layer, allowing capture of essential
      application observability events for HTTP/S and gRPC services.
    '';
    homepage = "https://github.com/grafana/beyla";
    changelog = "https://github.com/grafana/beyla/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [evanlhatch];
    mainProgram = "beyla";
    platforms = lib.platforms.linux;
  };
})
