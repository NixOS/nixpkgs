{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-fastcom-exporter";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "fastcom-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fWHEAhdkNGGPvUybanaaUJu4vZ2iwIgOcoU8iHRTrI4=";
  };

  vendorHash = "sha256-B7Wc1htpXN7yRoKTEEWvfH8QST52ZfgHLBZPfBSTsD0=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) fastcom; };

  ldflags = [
    "-s"
    "-w"
    "-X main.builtBy=nixpkgs"
    "-X main.commit=unknown"
    "-X main.date=unknown"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/caarlos0/fastcom-exporter";
    description = "Exports Fast.com speedtest results as prometheus metrics";
    mainProgram = "fastcom-exporter";
    maintainers = with lib.maintainers; [ emaiax ];
    license = lib.licenses.asl20;
  };
})
