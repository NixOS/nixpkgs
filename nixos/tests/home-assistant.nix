import ./make-test-python.nix ({ pkgs, ... }:

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
                {
                  type = "legacy_api_password";
                  api_password = apiPassword;
                }
              ];
            };
            frontend = { };
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
          lovelaceConfig = {
            title = "My Awesome Home";
            views = [ {
              title = "Example";
              cards = [ {
                type = "markdown";
                title = "Lovelace";
                content = "Welcome to your **Lovelace UI**.";
              } ];
            } ];
          };
          lovelaceConfigWritable = true;
        };
      };
  };

  testScript = ''
    start_all()
    hass.wait_for_unit("home-assistant.service")
    with subtest("Check that YAML configuration file is in place"):
        hass.succeed("test -L ${configDir}/configuration.yaml")
    with subtest("lovelace config is copied because lovelaceConfigWritable = true"):
        hass.succeed("test -f ${configDir}/ui-lovelace.yaml")
    with subtest("Check that Home Assistant's web interface and API can be reached"):
        hass.wait_for_open_port(8123)
        hass.succeed("curl --fail http://localhost:8123/states")
        assert "API running" in hass.succeed(
            "curl --fail -H 'x-ha-access: ${apiPassword}' http://localhost:8123/api/"
        )
    with subtest("Toggle a binary sensor using MQTT"):
        assert '"state": "off"' in hass.succeed(
            "curl http://localhost:8123/api/states/binary_sensor.mqtt_binary_sensor -H 'x-ha-access: ${apiPassword}'"
        )
        hass.wait_until_succeeds(
            "mosquitto_pub -V mqttv311 -t home-assistant/test -u homeassistant -P '${mqttPassword}' -m let_there_be_light"
        )
        assert '"state": "on"' in hass.succeed(
            "curl http://localhost:8123/api/states/binary_sensor.mqtt_binary_sensor -H 'x-ha-access: ${apiPassword}'"
        )
    with subtest("Toggle a binary sensor using hass-cli"):
        assert '"state": "on"' in hass.succeed(
            "${hassCli} --output json state get binary_sensor.mqtt_binary_sensor"
        )
        hass.succeed(
            "${hassCli} state edit binary_sensor.mqtt_binary_sensor --json='{\"state\": \"off\"}'"
        )
        assert '"state": "off"' in hass.succeed(
            "curl http://localhost:8123/api/states/binary_sensor.mqtt_binary_sensor -H 'x-ha-access: ${apiPassword}'"
        )
    with subtest("Print log to ease debugging"):
        output_log = hass.succeed("cat ${configDir}/home-assistant.log")
        print("\n### home-assistant.log ###\n")
        print(output_log + "\n")

    with subtest("Check that no errors were logged"):
        assert "ERROR" not in output_log
  '';
})
