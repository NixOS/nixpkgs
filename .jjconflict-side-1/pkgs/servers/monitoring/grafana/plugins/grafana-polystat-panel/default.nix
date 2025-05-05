{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "grafana-polystat-panel";
  version = "2.1.14";
  zipHash = "sha256-W6qx3b8rmIQV6Sm2rUsCDKrWi69N2S31hbmuqjYt25M=";
  meta = with lib; {
    description = "Hexagonal multi-stat panel for Grafana";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = platforms.unix;
  };
}
