{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pgbouncer-exporter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "pgbouncer_exporter";
    rev = "v${version}";
    hash = "sha256-Kt3eM8CxDOTWgMppAs+ajt4RL6Q/7jMcKYQIFzlRW8g=";
  };

  vendorHash = "sha256-h9IJAjTCSKrREolo4DVOzULguz4gj6UbkFSR9yuivQY=";

  meta = {
    description = "Prometheus exporter for PgBouncer";
    mainProgram = "pgbouncer_exporter";
    homepage = "https://github.com/prometheus-community/pgbouncer_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.linux;
  };
}
