{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-8ChYYJIHdzH2vWxqnzS6sz9fDeLe+Y29fzia3/aBkgc=";
  };

  vendorHash = "sha256-PjoS56MdYpDOuSTHHo5lGL9KlWlu3ycA08qim8jrnSU=";

  meta = with lib; {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 ];
    platforms = platforms.linux;
  };
}
