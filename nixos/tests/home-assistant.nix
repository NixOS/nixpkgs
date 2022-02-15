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

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "hass" ];
      ensureUsers = [{
        name = "hass";
        ensurePermissions = {
          "DATABASE hass" = "ALL PRIVILEGES";
        };
      }];
    };

    services.home-assistant = {
      enable = true;
      inherit configDir;

      # tests loading components by overriding the package
      package = (pkgs.home-assistant.override {
        extraPackages = ps: with ps; [
          colorama
        ];
        extraComponents = [ "zha" ];
      }).overrideAttrs (oldAttrs: {
        doInstallCheck = false;
      });

      # tests loading components from the module
      extraComponents = [
        "wake_on_lan"
      ];

      # test extra package passing from the module
      extraPackages = python3Packages: with python3Packages; [
        psycopg2
      ];

      config = {
        homeassistant = {
          name = "Home";
          time_zone = "UTC";
          latitude = "0.0";
          longitude = "0.0";
          elevation = 0;
        };

        # configure the recorder component to use the postgresql db
        recorder.db_url = "postgresql://@/hass";

        # we can't load default_config, because the updater requires
        # network access and would cause an error, so load frontend
        # here explicitly.
        # https://www.home-assistant.io/integrations/frontend/
        frontend = {};

        # configure an mqtt broker connection
        # https://www.home-assistant.io/integrations/mqtt
        mqtt = {
          broker = "127.0.0.1";
          username = mqttUsername;
          password = mqttPassword;
        };

        # create a mqtt sensor that syncs state with its mqtt topic
        # https://www.home-assistant.io/integrations/sensor.mqtt/
        binary_sensor = [ {
          platform = "mqtt";
          state_topic = "home-assistant/test";
          payload_on = "let_there_be_light";
          payload_off = "off";
        } ];

        # set up a wake-on-lan switch to test capset capability required
        # for the ping suid wrapper
        # https://www.home-assistant.io/integrations/wake_on_lan/
        switch = [ {
          platform = "wake_on_lan";
          mac = "00:11:22:33:44:55";
          host = "127.0.0.1";
        } ];

        # test component-based capability assignment (CAP_NET_BIND_SERVICE)
        # https://www.home-assistant.io/integrations/emulated_hue/
        emulated_hue = {
          host_ip = "127.0.0.1";
          listen_port = 80;
        };

        # show mqtt interaction in the log
        # https://www.home-assistant.io/integrations/logger/
        logger = {
          default = "info";
          logs."homeassistant.components.mqtt" = "debug";
        };
      };

      # configure the sample lovelace dashboard
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
    import re

    start_all()

    # Parse the package path out of the systemd unit, as we cannot
    # access the final package, that is overriden inside the module,
    # by any other means.
    pattern = re.compile(r"path=(?P<path>[\/a-z0-9-.]+)\/bin\/hass")
    response = hass.execute("systemctl show -p ExecStart home-assistant.service")[1]
    match = pattern.search(response)
    package = match.group('path')

    hass.wait_for_unit("home-assistant.service")

    with subtest("Check that YAML configuration file is in place"):
        hass.succeed("test -L ${configDir}/configuration.yaml")

    with subtest("Check the lovelace config is copied because lovelaceConfigWritable = true"):
        hass.succeed("test -f ${configDir}/ui-lovelace.yaml")

    with subtest("Check extraComponents and extraPackages are considered from the package"):
        hass.succeed(f"grep -q 'colorama' {package}/extra_packages")
        hass.succeed(f"grep -q 'zha' {package}/extra_components")

    with subtest("Check extraComponents and extraPackages are considered from the module"):
        hass.succeed(f"grep -q 'psycopg2' {package}/extra_packages")
        hass.succeed(f"grep -q 'wake_on_lan' {package}/extra_components")

    with subtest("Check that Home Assistant's web interface and API can be reached"):
        hass.wait_until_succeeds("journalctl -u home-assistant.service | grep -q 'Home Assistant initialized in'")
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

    with subtest("Check that no errors were logged"):
        assert "ERROR" not in output_log

    # example line: 2020-06-20 10:01:32 DEBUG (MainThread) [homeassistant.components.mqtt] Received message on home-assistant/test: b'let_there_be_light'
    with subtest("Check we received the mosquitto message"):
        assert "let_there_be_light" in output_log

    with subtest("Check systemd unit hardening"):
        hass.log(hass.succeed("systemctl cat home-assistant.service"))
        hass.log(hass.succeed("systemd-analyze security home-assistant.service"))
  '';
})
