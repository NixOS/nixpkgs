{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "10.4.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-oqrCqT067lx6RbIBOHsKTJVzHyrCHI1dJmmOO8GgqGg=";
  };

  vendorHash = "sha256-O5FDjG01YozioA7EXfqY1q1DMmUuHQIkdp+egoJNg3A=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    mainProgram = "fastly-exporter";
  };
}
