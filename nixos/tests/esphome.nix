{ pkgs, lib, ... }:

{
  name = "esphome";
  meta.maintainers = with lib.maintainers; [
    thanegill
    oddlama
  ];

  nodes = {
    machine =
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
          cores = 2;
          memorySize = 2048;
          # Need larger disk for platformio downloads
          diskSize = 4096;
        };

        environment.systemPackages = [ pkgs.esphome ];

        systemd.tmpfiles.rules = [
          "C+ /root/${esp8266.name} - - - - ${esp8266}"
          "C+ /root/${esp32Arduino.name} - - - - ${esp32Arduino}"
          "C+ /root/${esp32Esp-idf.name} - - - - ${esp32Esp-idf}"
        ];
      };
  };

  testScript = ''
    machine.succeed("esphome -v config /root/test-esp8266.yaml 2>&1")
    machine.succeed("esphome -v compile /root/test-esp8266.yaml 2>&1")

    machine.succeed("esphome -v config /root/test-esp32-arduino.yaml 2>&1")
    machine.succeed("esphome -v compile /root/test-esp32-arduino.yaml 2>&1")

    machine.succeed("esphome -v config /root/test-esp32-esp-idf.yaml 2>&1")
    machine.succeed("esphome -v compile /root/test-esp32-esp-idf.yaml 2>&1")
  '';
}
