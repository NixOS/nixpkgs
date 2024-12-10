import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    configDir = "/var/lib/foobar";
  in
  {
    name = "home-assistant";
    meta.maintainers = lib.teams.home-assistant.members;

    nodes.hass =
      { pkgs, ... }:
      {
        services.postgresql = {
          enable = true;
          ensureDatabases = [ "hass" ];
          ensureUsers = [
            {
              name = "hass";
              ensureDBOwnership = true;
            }
          ];
        };

        services.home-assistant = {
          enable = true;
          inherit configDir;

          # provide dependencies through package overrides
          package = (
            pkgs.home-assistant.override {
              extraPackages =
                ps: with ps; [
                  colorama
                ];
              extraComponents = [
                # test char-tty device allow propagation into the service
                "zha"
              ];
            }
          );

          # provide component dependencies explicitly from the module
          extraComponents = [
            "mqtt"
          ];

          # provide package for postgresql support
          extraPackages =
            python3Packages: with python3Packages; [
              psycopg2
            ];

          # test loading custom components
          customComponents = with pkgs.home-assistant-custom-components; [
            prometheus_sensor
            # tests loading multiple components from a single package
            spook
          ];

          # test loading lovelace modules
          customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
            mini-graph-card
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
            frontend = { };

            # include some popular integrations, that absolutely shouldn't break
            knx = { };
            shelly = { };
            zha = { };

            # set up a wake-on-lan switch to test capset capability required
            # for the ping suid wrapper
            # https://www.home-assistant.io/integrations/wake_on_lan/
            switch = [
              {
                platform = "wake_on_lan";
                mac = "00:11:22:33:44:55";
                host = "127.0.0.1";
              }
            ];

            # test component-based capability assignment (CAP_NET_BIND_SERVICE)
            # https://www.home-assistant.io/integrations/emulated_hue/
            emulated_hue = {
              host_ip = "127.0.0.1";
              listen_port = 80;
            };

            # https://www.home-assistant.io/integrations/logger/
            logger = {
              default = "info";
            };
          };

          # configure the sample lovelace dashboard
          lovelaceConfig = {
            title = "My Awesome Home";
            views = [
              {
                title = "Example";
                cards = [
                  {
                    type = "markdown";
                    title = "Lovelace";
                    content = "Welcome to your **Lovelace UI**.";
                  }
                ];
              }
            ];
          };
          lovelaceConfigWritable = true;
        };

        # Cause a configuration change inside `configuration.yml` and verify that the process is being reloaded.
        specialisation.differentName = {
          inheritParentConfig = true;
          configuration.services.home-assistant.config.homeassistant.name = lib.mkForce "Test Home";
        };

        # Cause a configuration change that requires a service restart as we added a new runtime dependency
        specialisation.newFeature = {
          inheritParentConfig = true;
          configuration.services.home-assistant.config.backup = { };
        };

        specialisation.removeCustomThings = {
          inheritParentConfig = true;
          configuration.services.home-assistant = {
            customComponents = lib.mkForce [ ];
            customLovelaceModules = lib.mkForce [ ];
          };
        };
      };

    testScript =
      { nodes, ... }:
      let
        system = nodes.hass.system.build.toplevel;
      in
      ''
        import json

        start_all()


        def get_journal_cursor() -> str:
            exit, out = hass.execute("journalctl -u home-assistant.service -n1 -o json-pretty --output-fields=__CURSOR")
            assert exit == 0
            return json.loads(out)["__CURSOR"]


        def get_journal_since(cursor) -> str:
            exit, out = hass.execute(f"journalctl --after-cursor='{cursor}' -u home-assistant.service")
            assert exit == 0
            return out


        def get_unit_property(property) -> str:
            exit, out = hass.execute(f"systemctl show --property={property} home-assistant.service")
            assert exit == 0
            return out


        def wait_for_homeassistant(cursor):
            hass.wait_until_succeeds(f"journalctl --after-cursor='{cursor}' -u home-assistant.service | grep -q 'Home Assistant initialized in'")


        hass.wait_for_unit("home-assistant.service")
        cursor = get_journal_cursor()

        with subtest("Check that YAML configuration file is in place"):
            hass.succeed("test -L ${configDir}/configuration.yaml")

        with subtest("Check the lovelace config is copied because lovelaceConfigWritable = true"):
            hass.succeed("test -f ${configDir}/ui-lovelace.yaml")

        with subtest("Check that Home Assistant's web interface and API can be reached"):
            wait_for_homeassistant(cursor)
            hass.wait_for_open_port(8123)
            hass.succeed("curl --fail http://localhost:8123/lovelace")

        with subtest("Check that custom components get installed"):
            hass.succeed("test -f ${configDir}/custom_components/prometheus_sensor/manifest.json")
            for integration in ("prometheus_sensor", "spook", "spook_inverse"):
                hass.wait_until_succeeds(f"journalctl -u home-assistant.service | grep -q 'We found a custom integration {integration} which has not been tested by Home Assistant'")

        with subtest("Check that lovelace modules are referenced and fetchable"):
            hass.succeed("grep -q 'mini-graph-card-bundle.js' '${configDir}/configuration.yaml'")
            hass.succeed("curl --fail http://localhost:8123/local/nixos-lovelace-modules/mini-graph-card-bundle.js")

        with subtest("Check that optional dependencies are in the PYTHONPATH"):
            env = get_unit_property("Environment")
            python_path = env.split("PYTHONPATH=")[1].split()[0]
            for package in ["colorama", "paho-mqtt", "psycopg2"]:
                assert package in python_path, f"{package} not in PYTHONPATH"

        with subtest("Check that declaratively configured components get setup"):
            journal = get_journal_since(cursor)
            for domain in ["emulated_hue", "wake_on_lan"]:
                assert f"Setup of domain {domain} took" in journal, f"{domain} setup missing"

        with subtest("Check that capabilities are passed for emulated_hue to bind to port 80"):
            hass.wait_for_open_port(80)
            hass.succeed("curl --fail http://localhost:80/description.xml")

        with subtest("Check extra components are considered in systemd unit hardening"):
            hass.succeed("systemctl show -p DeviceAllow home-assistant.service | grep -q char-ttyUSB")

        with subtest("Check service reloads when configuration changes"):
            pid = hass.succeed("systemctl show --property=MainPID home-assistant.service")
            cursor = get_journal_cursor()
            hass.succeed("${system}/specialisation/differentName/bin/switch-to-configuration test")
            new_pid = hass.succeed("systemctl show --property=MainPID home-assistant.service")
            assert pid == new_pid, "The PID of the process should not change between process reloads"
            wait_for_homeassistant(cursor)

        with subtest("Check service restarts when dependencies change"):
            pid = new_pid
            cursor = get_journal_cursor()
            hass.succeed("${system}/specialisation/newFeature/bin/switch-to-configuration test")
            new_pid = hass.succeed("systemctl show --property=MainPID home-assistant.service")
            assert pid != new_pid, "The PID of the process should change when its PYTHONPATH changess"
            wait_for_homeassistant(cursor)

        with subtest("Check that new components get setup after restart"):
            journal = get_journal_since(cursor)
            for domain in ["backup"]:
                assert f"Setup of domain {domain} took" in journal, f"{domain} setup missing"

        with subtest("Check custom components and custom lovelace modules get removed"):
            cursor = get_journal_cursor()
            hass.succeed("${system}/specialisation/removeCustomThings/bin/switch-to-configuration test")
            hass.fail("grep -q 'mini-graph-card-bundle.js' '${configDir}/ui-lovelace.yaml'")
            for integration in ("prometheus_sensor", "spook", "spook_inverse"):
                hass.fail(f"test -f ${configDir}/custom_components/{integration}/manifest.json")
            wait_for_homeassistant(cursor)

        with subtest("Check that no errors were logged"):
            hass.fail("journalctl -u home-assistant -o cat | grep -q ERROR")

        with subtest("Check systemd unit hardening"):
            hass.log(hass.succeed("systemctl cat home-assistant.service"))
            hass.log(hass.succeed("systemd-analyze security home-assistant.service"))
      '';
  }
)
