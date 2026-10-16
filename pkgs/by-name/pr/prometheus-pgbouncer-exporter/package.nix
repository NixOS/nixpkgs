{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-P82ek6+OcvRd1dIuqkfqU4DEmOtHVkSfN5atLansCK4=";
  };

  vendorHash = "sha256-wKb5/phioGYLthgFVlh0OkVzJyPynAl2G9v89550k6M=";

  meta = {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.linux;
  };
}
