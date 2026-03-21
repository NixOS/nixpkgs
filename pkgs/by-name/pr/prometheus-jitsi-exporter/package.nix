{
  lib,
  buildGoModule,
  fetchgit,
  nixosTests,
}:

buildGoModule rec {
  pname = "jitsiexporter";
  version = "0.2.18";

  src = fetchgit {
    url = "https://git.xsfx.dev/prometheus/jitsiexporter";
    rev = "v${version}";
    sha256 = "1cf46wp96d9dwlwlffcgbcr0v3xxxfdv6il0zqkm2i7cfsfw0skf";
  };

  vendorHash = null;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) jitsi; };

  meta = {
    description = "Export Jitsi Videobridge metrics to Prometheus";
    mainProgram = "jitsiexporter";
    homepage = "https://git.xsfx.dev/prometheus/jitsiexporter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
