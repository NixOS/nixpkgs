{ config, lib, ... }:

{
  name = "glance";

  nodes = {
    machine_default =
      { ... }:
      {
        services.glance = {
          enable = true;
        };
      };

    machine_configured =
      { pkgs, ... }:
      let
        # Do not use this in production. This will make the secret world-readable
        # in the Nix store
        secrets.glance-location.path = builtins.toString (
          pkgs.writeText "location-secret" "Nivelles, Belgium"
        );
      in
      {
        services.glance = {
          enable = true;
          settings = {
            server.port = 5678;
            pages = [
              {
                name = "Home";
                columns = [
                  {
                    size = "full";
                    widgets = [
                      { type = "calendar"; }
                      {
                        type = "weather";
                        location = {
                          _secret = secrets.glance-location.path;
                        };
                      }
                    ];
                  }
                ];
              }
            ];
          };
        };
      };
  };

  extraPythonPackages =
    p: with p; [
      beautifulsoup4
      pyyaml
      types-pyyaml
      types-beautifulsoup4
    ];

  testScript = ''
    from bs4 import BeautifulSoup
    import yaml

    machine_default.start()
    machine_default.wait_for_unit("glance.service")
    machine_default.wait_for_open_port(8080)

    machine_configured.start()
    machine_configured.wait_for_unit("glance.service")
    machine_configured.wait_for_open_port(5678)

    soup = BeautifulSoup(machine_default.succeed("curl http://localhost:8080"))
    expected_version = "v${config.nodes.machine_default.services.glance.package.version}"
    assert any(a.text == expected_version for a in soup.select(".footer a"))

    yaml_contents = machine_configured.succeed("cat /run/glance/glance.yaml")
    yaml_parsed = yaml.load(yaml_contents, Loader=yaml.FullLoader)
    location = yaml_parsed["pages"][0]["columns"][0]["widgets"][1]["location"]
    assert location == "Nivelles, Belgium"
  '';

  meta.maintainers = [ ];
}
