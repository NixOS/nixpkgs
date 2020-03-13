import ./make-test-python.nix ({ pkgs, ... }:

let
  configDir = "/var/lib/hass";
  configFile = "${configDir}/configuration.yaml";
  port = 4000;

  mkHass = { machineAttrs ? {}, hassAttrs ? {} }:
      { pkgs, ... }:
      {
        services.home-assistant = {
          inherit configDir port;
          enable = true;
        } // hassAttrs;
      } // machineAttrs;
in {
  name = "home-assistant-config";

  nodes = {
    hassMinimal = mkHass {};

    hassTimeZone = mkHass {
      machineAttrs = { time.timeZone = "UTC"; };
    };

    hassNoDefault = mkHass {
      hassAttrs = { applyDefaultConfig = false; };
    };
  };

  testScript = let
    portStr = toString port;
  in ''
    start_all()


    def check_availability(hass):
        hass.wait_for_unit("home-assistant.service")
        with subtest("Check that Home Assistant can be reached via port ${portStr}"):
            hass.wait_for_open_port(${portStr})
            hass.succeed("curl --fail http://localhost:${portStr}")


    check_availability(hassMinimal)
    with subtest("Check that port is set"):
        config = hassMinimal.succeed("cat ${configFile}")
        assert "server_port: ${portStr}" in config

    check_availability(hassTimeZone)
    with subtest("Check that default_config, port and time_zone are set"):
        config = hassTimeZone.succeed("cat ${configFile}")
        assert "server_port: ${portStr}" in config
        assert "time_zone: UTC" in config

    hassNoDefault.wait_for_unit("home-assistant.service")

    with subtest("Check that server port is not set"):
        config = hassNoDefault.succeed("cat ${configFile}")
        assert "server_port: ${portStr}" not in config

    # It cannot be reached because defaults (i.e. http.server_port, frontend) are not set
    with subtest("Check that Home Assistant cannot be reached via port ${portStr}"):
        hassNoDefault.wait_for_closed_port(${portStr})
  '';
})
