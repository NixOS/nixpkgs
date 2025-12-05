{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "speedtest-exporter";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "speedtest-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LKQVmGnKbznHHFZpa/SaqeMuCGUblnuYkZcsreq4f04=";
  };
  vendorHash = "sha256-KshKcOZOIrvjJ1vW/zuKo7yhrC4BGWial+AoYNXADGk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.builtBy=nixpkgs"
    "-X main.commit=unknown"
    "-X main.date=unknown"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) speedtest; };

  meta = {
    homepage = "https://github.com/caarlos0/speedtest-exporter";
    description = "Exports speedtests as prometheus metrics";
    mainProgram = "speedtest-exporter";
    maintainers = with lib.maintainers; [ emaiax ];
    license = lib.licenses.asl20;
  };
})
