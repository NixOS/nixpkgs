{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-afIO6lo2eeAHMhz3VTsEvBUZYCVNenHdjG/YM/Dpz/A=";
  };

  vendorHash = "sha256-QfCB3t1J5fTcTV1h91I/82fWXvuqrH4F7ksvKvB9zrw=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "nextcloud-exporter";
  };
}
