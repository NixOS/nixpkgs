import ./make-test.nix ({ pkgs, ... }:

let
  configDir = "/var/lib/foobar";

in {
  name = "home-assistant";

  nodes = {
    hass =
      { config, pkgs, ... }:
      {
        services.home-assistant = {
          inherit configDir;
          enable = true;
          config = {
            homeassistant = {
              name = "Home";
              time_zone = "UTC";
            };
            frontend = { };
            http = { };
          };
        };
      };
    };

  testScript = ''
    startAll;
    $hass->waitForUnit("home-assistant.service");
    
    # Since config is specified using a Nix attribute set,
    # configuration.yaml is a link to the Nix store
    $hass->succeed("test -L ${configDir}/configuration.yaml");

    # Check that Home Assistant's web interface and API can be reached
    $hass->waitForOpenPort(8123);
    $hass->succeed("curl --fail http://localhost:8123/states");
    $hass->succeed("curl --fail http://localhost:8123/api/ | grep 'API running'");
  '';
})
