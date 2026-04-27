{ lib, ... }:
{
  name = "homepage-dashboard";
  meta.maintainers = with lib.maintainers; [ parthiv-krishna ];

  nodes.machine = _: {
    services.homepage-dashboard = {
      enable = true;
      settings.title = "test title rodUsEagid"; # something random/unique
      bookmarks = [
        {
          Developer = [
            {
              nixpkgs = [
                {
                  abbr = "NX";
                  href = "https://github.com/nixos/nixpkgs";
                }
              ];
            }
          ];
        }
      ];
      services = [
        {
          Machines = [
            {
              Localhost = {
                ping = "127.0.0.1";
              };
            }
          ];
        }
      ];
    };
  };

  testScript = ''
    import json

    # Ensure the services are started on managed machine
    machine.wait_for_unit("homepage-dashboard.service")
    machine.wait_for_open_port(8082)
    machine.succeed("curl --fail http://localhost:8082/")

    # Ensure /etc/homepage-dashboard is created.
    machine.succeed("test -d /etc/homepage-dashboard")

    # Ensure that we see the custom title reflected in the manifest
    page = machine.succeed("curl --fail http://localhost:8082/site.webmanifest?v=4")
    assert "test title rodUsEagid" in page, "Custom title not found"

    # Ensure that we see the custom bookmarks on the page
    page = machine.succeed("curl --fail http://127.0.0.1:8082/api/bookmarks")
    assert "nixpkgs" in page, "Custom bookmarks not found"

    # Ensure that the ping command works
    response = machine.succeed("curl --fail \"http://localhost:8082/api/ping?groupName=Machines&serviceName=Localhost\"")
    assert json.loads(response)["alive"] is True, "Ping to localhost failed"
  '';
}
