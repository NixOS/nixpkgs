import ./make-test.nix ({ pkgs, ... }:

let
  configDir = "/var/lib/foobar";
  apiPassword = "some_secret";
  mqttPassword = "another_secret";
  hassCli = "hass-cli --server http://hass:8123 --password '${apiPassword}'";

in {
  name = "home-assistant";
  meta = with pkgs.stdenv.lib; {
    maintainers = with maintainers; [ dotlambda ];
  };

  nodes = {
    hass =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mosquitto home-assistant-cli
        ];
        services.home-assistant = {
          inherit configDir;
          enable = true;
          package = pkgs.home-assistant.override {
            extraPackages = ps: with ps; [ hbmqtt ];
          };
          config = {
            homeassistant = {
              name = "Home";
              time_zone = "UTC";
              latitude = "0.0";
              longitude = "0.0";
              elevation = 0;
              auth_providers = [
                { type = "legacy_api_password"; }
              ];
            };
            frontend = { };
            http.api_password = apiPassword;
            mqtt = { # Use hbmqtt as broker
              password = mqttPassword;
            };
            binary_sensor = [
              {
                platform = "mqtt";
                state_topic = "home-assistant/test";
                payload_on = "let_there_be_light";
                payload_off = "off";
              }
            ];
          };
        };
      };
  };

  testScript = ''
    startAll;
    $hass->waitForUnit("home-assistant.service");

    # The config is specified using a Nix attribute set,
    # but then converted from JSON to YAML
    $hass->succeed("test -f ${configDir}/configuration.yaml");

    # Check that Home Assistant's web interface and API can be reached
    $hass->waitForOpenPort(8123);
    $hass->succeed("curl --fail http://localhost:8123/states");
    $hass->succeed("curl --fail -H 'x-ha-access: ${apiPassword}' http://localhost:8123/api/ | grep -qF 'API running'");

    # Toggle a binary sensor using MQTT
    $hass->succeed("curl http://localhost:8123/api/states/binary_sensor.mqtt_binary_sensor -H 'x-ha-access: ${apiPassword}' | grep -qF '\"state\": \"off\"'");
    $hass->waitUntilSucceeds("mosquitto_pub -V mqttv311 -t home-assistant/test -u homeassistant -P '${mqttPassword}' -m let_there_be_light");
    $hass->succeed("curl http://localhost:8123/api/states/binary_sensor.mqtt_binary_sensor -H 'x-ha-access: ${apiPassword}' | grep -qF '\"state\": \"on\"'");

    # Toggle a binary sensor using hass-cli
    $hass->succeed("${hassCli} entity get binary_sensor.mqtt_binary_sensor | grep -qF '\"state\": \"on\"'");
    $hass->succeed("${hassCli} entity edit binary_sensor.mqtt_binary_sensor --json='{\"state\": \"off\"}'");
    $hass->succeed("curl http://localhost:8123/api/states/binary_sensor.mqtt_binary_sensor -H 'x-ha-access: ${apiPassword}' | grep -qF '\"state\": \"off\"'");

    # Print log to ease debugging
    my $log = $hass->succeed("cat ${configDir}/home-assistant.log");
    print "\n### home-assistant.log ###\n";
    print "$log\n";

    # Check that no errors were logged
    $hass->fail("cat ${configDir}/home-assistant.log | grep -qF ERROR");
  '';
})
