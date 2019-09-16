import ./make-test.nix ({ lib, pkgs, ... }:

{
  name = "loki";

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };

  machine = { ... }: {
    services.loki = {
      enable = true;
      configFile = "${pkgs.grafana-loki.src}/cmd/loki/loki-local-config.yaml";
    };
    systemd.services.promtail = {
      description = "Promtail service for Loki test";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.grafana-loki}/bin/promtail --config.file ${pkgs.grafana-loki.src}/cmd/promtail/promtail-local-config.yaml
        '';
        DynamicUser = true;
      };
    };
  };

  testScript = ''
    $machine->start;
    $machine->waitForUnit("loki.service");
    $machine->waitForUnit("promtail.service");
    $machine->waitForOpenPort(3100);
    $machine->waitForOpenPort(9080);
    $machine->succeed("echo 'Loki Ingestion Test' > /var/log/testlog");
    $machine->waitUntilSucceeds("${pkgs.grafana-loki}/bin/logcli --addr='http://localhost:3100' query --no-labels '{job=\"varlogs\",filename=\"/var/log/testlog\"}' | grep -q 'Loki Ingestion Test'");
  '';
})
