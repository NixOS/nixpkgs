{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libbpf,
  elfutils,
  zlib,
  pkg-config,
  llvmPackages,
}:
buildGoModule (finalAttrs: {
  pname = "otel-ebpf-profiler";
  version = "0.0.202606";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-ebpf-profiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G3mbz0DJhTOJ2EyPwu8jfoLTeAKrBxNtzgySfW7zTbU=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-FsmprnK+RFdfUsUYwCRYwFnGqep+DVTUsQ92+44UV4Q=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
  ];

  buildInputs = [
    libbpf
    elfutils
    zlib
  ];

  env = {
    CGO_ENABLED = "1";
    CC = "clang";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Continuous profiling for OpenTelemetry using eBPF";
    homepage = "https://github.com/open-telemetry/opentelemetry-ebpf-profiler";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evanlhatch ];
    mainProgram = "ebpf-profiler";
    platforms = lib.platforms.linux;
  };
})
