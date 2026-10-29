{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "bind_exporter";
  version = "0.8.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
    sha256 = "sha256-r1P+zy3iMgPmfvIBgycW8KS0gfNOxCT9YMmHdeY4uXA=";
  };

  vendorHash = "sha256-/fPj5LOe3QdnVPdtYdaqtnGMJ7/SZ458mpvjwO8TxEI=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = {
    description = "Prometheus exporter for bind9 server";
    mainProgram = "bind_exporter";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rtreffer ];
  };
})
