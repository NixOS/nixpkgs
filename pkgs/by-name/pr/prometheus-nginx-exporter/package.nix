{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "nginx-prometheus-exporter";
    rev = "v${version}";
    sha256 = "sha256-TrLgMYzlvTWgGfFkpGziflx6t7k0zee7IlpTraBEinw=";
  };

  vendorHash = "sha256-56jLUx/0kJIa+rk0k/ZBuV18Egy00AmzHZnvKXWHjf0=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    mainProgram = "nginx-prometheus-exporter";
    homepage = "https://github.com/nginx/nginx-prometheus-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      benley
      fpletz
      globin
    ];
  };
}
