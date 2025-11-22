{ pkgs, lib, ... }:

{
  name = "esphome";
  meta.maintainers = with lib.maintainers; [
    thanegill
    oddlama
  ];

  nodes.machine =
    { pkgs, ... }:
    let

      mkEsphomeConfig =
        name: attrs:
        pkgs.writers.writeYAML "${name}.yaml" (
          {
            esphome.name = name;
            wifi.ssid = "test-ssid";
          }
          // attrs
        );

      esp8266 = mkEsphomeConfig "test-esp8266" {
        esp8266.board = "esp01_1m";
      };

      esp32Arduino = mkEsphomeConfig "test-esp32-arduino" {
        esp32 = {
          variant = "esp32";
          framework.type = "arduino";
        };
      };

      esp32Esp-idf = mkEsphomeConfig "test-esp32-esp-idf" {
        esp32 = {
          variant = "esp32";
          framework.type = "esp-idf";
        };
      };
    in
    {

      virtualisation = {
        cores = 4;
        memorySize = 4096;
        # Need larger disk for platformio downloads
        diskSize = 8192;
      };

      environment.systemPackages = [
        pkgs.esphome
      ];

      systemd.tmpfiles.rules = [
        "C+ /root/${esp8266.name} - - - - ${esp8266}"
        "C+ /root/${esp32Arduino.name} - - - - ${esp32Arduino}"
        "C+ /root/${esp32Esp-idf.name} - - - - ${esp32Esp-idf}"
      ];
    };

  testScript = ''
    machine.systemctl("start network-online.target")
    machine.wait_for_unit("network-online.target")

    machine.succeed("esphome -v config /root/test-esp8266.yaml >&2")
    machine.succeed("esphome -v compile /root/test-esp8266.yaml >&2")


    machine.succeed("rm -rf /root/.esphome /root/.platformio")
    machine.succeed("esphome -v config /root/test-esp32-arduino.yaml >&2")
    machine.succeed("esphome -v compile /root/test-esp32-arduino.yaml >&2")

    machine.succeed("rm -rf /root/.esphome /root/.platformio")
    machine.succeed("esphome -v config /root/test-esp32-esp-idf.yaml >&2")
    machine.succeed("esphome -v compile /root/test-esp32-esp-idf.yaml >&2")
  '';
}
