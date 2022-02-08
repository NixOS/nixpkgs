import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  configDir = "/var/lib/foobar";
  mqttUsername = "homeassistant";
  mqttPassword = "secret";
in {
  name = "home-assistant";
  meta.maintainers = lib.teams.home-assistant.members;

  nodes.hass = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ mosquitto ];
    services.mosquitto = {
      enable = true;
      listeners = [ {
        users = {
          "${mqttUsername}" = {
            acl = [ "readwrite #" ];
            password = mqttPassword;
          };
        };
      } ];
    };
    services.home-assistant = {
      inherit configDir;
      enable = true;
      package = (pkgs.home-assistant.override {
        extraComponents = [ "zha" ];
      }).overrideAttrs (oldAttrs: {
        doInstallCheck = false;
      });
      config = {
        homeassistant = {
          name = "Home";
          time_zone = "UTC";
          latitude = "0.0";
          longitude = "0.0";
          elevation = 0;
        };
        frontend = {};
        mqtt = {
          broker = "127.0.0.1";
          username = mqttUsername;
          password = mqttPassword;
        };
        binary_sensor = [{
          platform = "mqtt";
          state_topic = "home-assistant/test";
          payload_on = "let_there_be_light";
          payload_off = "off";
        }];
        wake_on_lan = {};
        switch = [{
          platform = "wake_on_lan";
          mac = "00:11:22:33:44:55";
          host = "127.0.0.1";
        }];
        # tests component-based capability assignment (CAP_NET_BIND_SERVICE)
        emulated_hue = {
          host_ip = "127.0.0.1";
          listen_port = 80;
        };
        logger = {
          default = "info";
          logs."homeassistant.components.mqtt" = "debug";
        };
      };
      lovelaceConfig = {
        title = "My Awesome Home";
        views = [{
          title = "Example";
          cards = [{
            type = "markdown";
            title = "Lovelace";
            content = "Welcome to your **Lovelace UI**.";
          }];
        }];
      };
      lovelaceConfigWritable = true;
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
        hass.succeed("curl --fail http://localhost:8123/lovelace")
    with subtest("Toggle a binary sensor using MQTT"):
        hass.wait_for_open_port(1883)
        hass.succeed(
            "mosquitto_pub -V mqttv5 -t home-assistant/test -u ${mqttUsername} -P '${mqttPassword}' -m let_there_be_light"
        )
    with subtest("Check that capabilities are passed for emulated_hue to bind to port 80"):
        hass.wait_for_open_port(80)
        hass.succeed("curl --fail http://localhost:80/description.xml")
    with subtest("Check extra components are considered in systemd unit hardening"):
        hass.succeed("systemctl show -p DeviceAllow home-assistant.service | grep -q char-ttyUSB")
    with subtest("Print log to ease debugging"):
        output_log = hass.succeed("cat ${configDir}/home-assistant.log")
        print("\n### home-assistant.log ###\n")
        print(output_log + "\n")

    # wait for home-assistant to fully boot
    hass.sleep(30)
    hass.wait_for_unit("home-assistant.service")

    with subtest("Check that no errors were logged"):
        assert "ERROR" not in output_log

    # example line: 2020-06-20 10:01:32 DEBUG (MainThread) [homeassistant.components.mqtt] Received message on home-assistant/test: b'let_there_be_light'
    with subtest("Check we received the mosquitto message"):
        assert "let_there_be_light" in output_log

    with subtest("Check systemd unit hardening"):
        hass.log(hass.succeed("systemctl show home-assistant.service"))
        hass.log(hass.succeed("systemd-analyze security home-assistant.service"))
  '';
})
