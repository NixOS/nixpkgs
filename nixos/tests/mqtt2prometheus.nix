import ./make-test-python.nix ({ lib, ... }:

let
  mosquittoPort = 1883;
  mqtt2PrometheusMetricsPort = 8080;
in
{
  name = "mqtt2prometheus";
  meta.maintainers = with lib.maintainers; [ lesuisse ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.mosquitto = {
        enable = true;
        listeners = [
          {
            address = "localhost";
            port = mosquittoPort;
            acl = [ "pattern readwrite #" ];
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };
      services.mqtt2prometheus = {
        enable = true;
        listenPort = mqtt2PrometheusMetricsPort;
        settings = {
          mqtt = {
            server = "tcp://localhost:${toString mosquittoPort}";
            topic_path = "test/+";
          };
          metrics = [
            {
              prom_name = "temperature";
              mqtt_name = "temperature";
              type = "gauge";
            }
          ];
        };
      };
      environment.systemPackages = [
        pkgs.mosquitto
      ];
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("mosquitto.service")
    machine.wait_for_unit("mqtt2prometheus.service")
    machine.wait_for_console_text("Connected to MQTT Broker")
    machine.succeed("mosquitto_pub -h localhost -p ${toString mosquittoPort} -t test/foo -m '{\"temperature\":20}']")
    machine.succeed("curl -sSfq http://localhost:${toString mqtt2PrometheusMetricsPort}/metrics | grep 'received_messages{status=\"success\",topic=\"test/foo\"} 1'")
  '';
})
