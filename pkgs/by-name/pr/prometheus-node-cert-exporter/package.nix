{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  nixosTests,
}:

buildGo122Module {
  pname = "node-cert-exporter";
  version = "1.1.7-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "amimof";
    repo = "node-cert-exporter";
    rev = "v1.1.7";
    sha256 = "sha256-VYJPgNVsfEs/zh/SEdOrFn0FK6S+hNFGDhonj2syutQ=";
  };

  vendorHash = "sha256-31MHX3YntogvoJmbOytl0rXS6qtdBSBJe8ejKyu6gqM=";

  # Required otherwise we get a few:
  # vendor/github.com/golang/glog/internal/logsink/logsink.go:129:41:
  # predeclared any requires go1.18 or later (-lang was set to go1.16; check go.mod)
  patches = [ ./gomod.patch ];

  meta = with lib; {
    description = "Prometheus exporter for SSL certificate";
    mainProgram = "node-cert-exporter";
    homepage = "https://github.com/amimof/node-cert-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ ibizaman ];
  };
}
